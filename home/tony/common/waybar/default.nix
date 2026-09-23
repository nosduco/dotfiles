{ pkgs, ... }:
let
  caffeine = pkgs.writeShellApplication {
    name = "waybar-caffeine";
    runtimeInputs = with pkgs; [
      procps
      systemd
    ];
    text = builtins.readFile ./caffeine.sh;
  };
in
{
  # waybar
  catppuccin.waybar.mode = "createLink";
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
    settings.main = import ./settings.nix;
  };
  home.packages = [ caffeine ];
}
