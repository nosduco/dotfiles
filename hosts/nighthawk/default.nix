{ pkgs, ... }:
{
  imports = [
    ../common/core
    ../common/optional/desktop.nix
    ../common/optional/gaming.nix
    ../common/optional/printing.nix
    ./dualsense.nix
    ./hardware.nix
  ];

  networking.hostName = "nighthawk";
  home-manager.users.tony = ../../home/tony/nighthawk;

  # stream deck
  programs.streamcontroller.enable = true;

  # oversteer
  services.udev.packages = [ pkgs.oversteer ];
}
