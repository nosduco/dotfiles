{ pkgs, ... }:
{
  imports = [
    ../common/core
    ../common/optional/desktop.nix
    ../common/optional/dev.nix
    ../common/optional/gaming.nix
    ../common/optional/printing.nix
    ../common/optional/work.nix
    ./dualsense.nix
    ./hardware.nix
  ];

  networking.hostName = "nighthawk";
  home-manager.users.tony = ../../home/tony/nighthawk;

  # stream deck
  programs.streamcontroller.enable = true;

  # udev
  services.udev.packages = [
    pkgs.oversteer
    pkgs.xr-hardware
  ];

  # ollama
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };
}
