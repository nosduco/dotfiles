{
  config,
  lib,
  pkgs,
  ...
}:
let
  monitors = config.host.monitors;
in
{
  # hyprland
  host.monitors = import ./monitors.nix;
  wayland.windowManager.hyprland.extraLuaFiles = {
    host = ./host.lua;
  };

  # env
  xdg.configFile."uwsm/env-hyprland".text = "export AQ_DRM_DEVICES=/dev/dri/card1";

  # dunst
  services.dunst.settings.global.monitor = monitors.main;

  # hypridle
  home.packages = [ pkgs.brightnessctl ];
  services.hypridle.settings = {
    general.after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
    listener = [
      {
        timeout = 150;
        on-timeout = "brightnessctl -s set 10";
        on-resume = "brightnessctl -r";
      }
      {
        timeout = 330;
        on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
        on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })' && brightnessctl -r";
      }
      {
        timeout = 1800;
        on-timeout = "systemctl suspend-then-hibernate";
      }
    ];
  };

  # hyprlock
  programs.hyprlock.settings = import ../common/hyprland/hyprlock.nix {
    monitor = "";
    brightness = 0.4;
  };
}
