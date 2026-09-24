{ osConfig, pkgs, ... }:
let
  kopia-backup = pkgs.writeShellApplication {
    name = "kopia-backup";
    runtimeInputs = with pkgs; [
      coreutils
      kopia
      libnotify
      openssh
    ];
    text = ''
      unreachable="''${XDG_STATE_HOME:-$HOME/.local/state}/kopia-unreachable"
      if ! timeout 5 bash -c '</dev/tcp/tux-pve.nosnet/22' 2>/dev/null; then
        if [ ! -e "$unreachable" ]; then
          mkdir -p "$(dirname "$unreachable")" && touch "$unreachable"
          notify-send -u critical -a System System "Backup failed: can't reach server. Retrying every 3 hours."
        fi
        exit 0
      fi
      rm -f "$unreachable"
      KOPIA_PASSWORD=$(cat ${osConfig.sops.secrets.kopia-password.path})
      export KOPIA_PASSWORD
      kopia repository status >/dev/null 2>&1 || kopia repository connect sftp \
        --host tux-pve.nosnet --username kopia \
        --path /tank/data/backups/endpoints/${osConfig.networking.hostName} \
        --external --ssh-command ssh
      kopia snapshot create --all
    '';
  };
in
{
  # kopia
  home.packages = with pkgs; [
    kopia
    kopia-ui
  ];
  systemd.user.services.kopia = {
    Unit = {
      Description = "kopia snapshots";
      OnFailure = [ "kopia-failed.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${kopia-backup}/bin/kopia-backup";
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };
  systemd.user.timers.kopia = {
    Unit.Description = "kopia snapshots";
    Timer = {
      OnCalendar = "0/3:00";
      Persistent = true;
      RandomizedDelaySec = "5min";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  # alerts
  systemd.user.services.kopia-failed = {
    Unit.Description = "kopia failure alert";
    Service = {
      Type = "oneshot";
      ExecStart = ''${pkgs.libnotify}/bin/notify-send -u critical -a System System "Backup failed. journalctl --user -u kopia"'';
    };
  };
}
