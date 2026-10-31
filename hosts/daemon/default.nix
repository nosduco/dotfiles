{ config, lib, ... }:
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

  # comin
  services.comin.exporter.openFirewall = true;

  # node exporter
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    extraFlags = [ "--collector.disable-defaults" ];
    openFirewall = true;
  };

  # qemu
  services.qemuGuest.enable = true;

  # linger
  users.users.tony.linger = true;

  # ovis
  systemd.services.tailscale-serve-ovis = {
    after = [
      "tailscaled.service"
      "tailscaled-set.service"
    ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${lib.getExe config.services.tailscale.package} serve --bg --https=443 http://127.0.0.1:7317";
    };
  };
}
