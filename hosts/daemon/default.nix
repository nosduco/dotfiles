{ lib, ... }:
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

  # qemu
  services.qemuGuest.enable = true;

  # linger
  users.users.tony.linger = true;
}
