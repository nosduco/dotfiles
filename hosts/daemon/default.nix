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

  # ssh
  networking.firewall.interfaces.ens18.allowedTCPPorts = [ 22 ];

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

  # comin
  services.comin.exporter.openFirewall = true;

  # node exporter
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
      "meminfo"
      "pressure"
    ];
    extraFlags = [ "--collector.disable-defaults" ];
    openFirewall = true;
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
