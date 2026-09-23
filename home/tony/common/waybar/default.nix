{ lib, pkgs, ... }:
let
  caffeine = pkgs.writeShellApplication {
    name = "waybar-caffeine";
    runtimeInputs = with pkgs; [
      procps
      systemd
    ];
    text = builtins.readFile ./caffeine.sh;
  };
  dunst-tray = pkgs.writeShellApplication {
    name = "waybar-dunst";
    runtimeInputs = with pkgs; [
      dunst
      gnugrep
    ];
    text = builtins.readFile ./dunst-tray.sh;
  };
in
{
  # waybar
  catppuccin.waybar.mode = "createLink";
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
    settings.main = lib.recursiveUpdate (import ./settings.nix) {
      "custom/dunst".exec = lib.getExe dunst-tray;
      "custom/weather".exec =
        "${lib.getExe pkgs.wttrbar} --location Columbus --fahrenheit --ampm --nerd --custom-indicator '{ICON} {temp_F}°'";
    };
  };
  home.packages = [ caffeine ];
}
