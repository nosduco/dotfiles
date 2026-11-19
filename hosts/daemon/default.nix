{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common/core
    ../common/optional/comin.nix
    ../common/optional/dev.nix
    ../common/optional/network.nix
    ../common/optional/work.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "daemon";
  home-manager.users.tony = ../../home/tony/daemon;

  # tailscale
  services.tailscale.extraSetFlags = lib.mkForce [ "--ssh" ];

  # lan
  networking.firewall.interfaces.ens18.allowedTCPPorts = [
    22
    config.services.comin.exporter.port
    config.services.prometheus.exporters.node.port
  ];

  # docker
  virtualisation.docker.enable = lib.mkForce false;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # auth logs
  services.rsyslogd = {
    enable = true;
    defaultConfig = "";
    extraConfig = ''
      if $syslogfacility-text == "auth" or $syslogfacility-text == "authpriv" then {
        action(type="omfwd" target="10.8.40.14" port="514" protocol="tcp" template="RSYSLOG_SyslogProtocol23Format" TCP_Framing="octet-counted" KeepAlive="on" queue.type="LinkedList" queue.size="10000" action.resumeRetryCount="-1")
      }
    '';
  };
  systemd.services.auth-log-heartbeat = {
    startAt = "hourly";
    serviceConfig.ExecStart = "${pkgs.util-linux}/bin/logger -p auth.info -t auth-heartbeat ok";
  };

  # node exporter
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
      "meminfo"
      "pressure"
      "filesystem"
    ];
    extraFlags = [
      "--collector.disable-defaults"
      "--collector.filesystem.mount-points-exclude=^/(dev|home|nix|proc|run|sys|tmp|var)"
    ];
  };

  # backup
  fileSystems."/backup" = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1";
    fsType = "ext4";
    autoFormat = true;
    options = [
      "noatime"
      "nofail"
    ];
  };
  systemd.services.work-backup = {
    startAt = "0/3:00";
    unitConfig.RequiresMountsFor = "/backup";
    serviceConfig = {
      Type = "oneshot";
      User = "tony";
      WorkingDirectory = config.users.users.tony.home;
      ExecStartPre = "+${pkgs.coreutils}/bin/install -d -o tony -g ${config.users.users.tony.group} -m 700 /backup/tony";
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.rsync)
        "--archive"
        "--delete"
        "--delete-excluded"
        "--filter=+ repos/"
        "--filter=+ docs/platform/"
        "--filter=+ .claude/"
        "--filter=+ .claude/worktrees/"
        "--filter=- .claude/*"
        "--filter=:- .gitignore"
        "work"
        "projects"
        ".dotfiles"
        "/backup/tony/"
      ];
      SuccessExitStatus = 24;
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };
  systemd.timers.work-backup.timerConfig = {
    Persistent = true;
    RandomizedDelaySec = "5min";
  };

  # qemu
  services.qemuGuest.enable = true;

  # earlyoom
  services.earlyoom = {
    enable = true;
    extraArgs = [
      "--ignore"
      "^(herdr|[.]claude-wrapped|codex|[.]?pi(-wrapped)?)$"
    ];
  };

  # zram
  zramSwap.memoryPercent = 100;

  # sysrq
  boot.kernel.sysctl."kernel.sysrq" = 80;

  # linger
  users.users.tony.linger = true;

  # ovis
  systemd.services.tailscale-serve-ovis = {
    after = [
      "tailscale-online.target"
      "tailscaled-set.service"
    ];
    wants = [ "tailscale-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${lib.getExe config.services.tailscale.package} serve --bg --https=443 http://127.0.0.1:7317";
    };
  };
}
