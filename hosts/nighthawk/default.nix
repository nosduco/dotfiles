{ pkgs, ... }:
{
  imports = [
    ../common/core
    ../common/optional/desktop.nix
    ../common/optional/dev.nix
    ../common/optional/gaming.nix
    ../common/optional/network.nix
    ../common/optional/printing.nix
    ../common/optional/secureboot.nix
    ../common/optional/work.nix
    ./audio.nix
    ./disko.nix
    ./dualsense.nix
    ./hardware-configuration.nix
    ./hardware.nix
  ];

  networking.hostName = "nighthawk";
  home-manager.users.tony = ../../home/tony/nighthawk;

  # tailscale
  services.tailscale.extraSetFlags = [ "--accept-dns=false" ];

  # dns
  services.resolved.settings.Resolve = {
    DNS = [ "10.8.8.1" ];
    Domains = [
      "~nosnet"
      "~tuxcloud.xyz"
    ];
  };

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
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "65536";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KEEP_ALIVE = "2h";
    };
  };
}
