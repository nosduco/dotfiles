{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  sources = map (dir: "${config.home.homeDirectory}/${dir}") [
    ".config"
    ".gnupg"
    ".ssh"
    "backups"
    "documents"
    "music"
    "notes"
    "pictures"
    "projects"
    "videos"
    "work"
  ];
  ignores = [
    # caches
    ".cache"
    "Cache"
    "Caches"
    "CacheStorage"
    "Code Cache"
    "DawnCache"
    "GPUCache"
    "GrShaderCache"
    "GraphiteDawnCache"
    "ShaderCache"
    # trash
    ".Trash-*"
    # dev
    "node_modules"
    "__pycache__"
    "*.pyc"
    ".venv"
    "venv"
    ".direnv"
    "target"
    ".gradle"
    ".next"
    ".turbo"
    # images
    "*.qcow2"
    "*.vmdk"
    "*.vdi"
    "*.iso"
    # temp
    "*.log"
    "*.swp"
    "*.part"
  ];
  policy = [
    "--keep-latest=10"
    "--keep-hourly=24"
    "--keep-daily=30"
    "--keep-weekly=12"
    "--keep-monthly=24"
    "--keep-annual=5"
    "--compression=zstd-fastest"
  ];
  target = "${config.home.username}@${osConfig.networking.hostName}";
  stamp = builtins.hashString "sha256" (builtins.toJSON [
    policy
    ignores
  ]);
  kopia-backup = pkgs.writeShellApplication {
    name = "kopia-backup";
    runtimeInputs = with pkgs; [
      coreutils
      jq
      kopia
      libnotify
      openssh
    ];
    text = ''
      state="''${XDG_STATE_HOME:-$HOME/.local/state}"
      unreachable="$state/kopia-unreachable"
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
      if [ "$(cat "$state/kopia-policy" 2>/dev/null)" != ${stamp} ]; then
        args=()
        while IFS= read -r p; do
          [ -n "$p" ] && args+=(--remove-ignore "$p")
        done < <(kopia policy show ${target} --json | jq -r '.files.ignore[]?')
        kopia policy set ${target} ${lib.escapeShellArgs policy} "''${args[@]}"
        kopia policy set ${target} ${
          lib.escapeShellArgs (lib.concatMap (p: [ "--add-ignore" p ]) ignores)
        }
        mkdir -p "$state" && echo ${stamp} > "$state/kopia-policy"
      fi
      kopia snapshot create ${lib.escapeShellArgs sources}
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
