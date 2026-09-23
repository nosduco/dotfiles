{ lib, ... }:
let
  monitors = import ./monitors.nix;
in
{
  # hyprland
  wayland.windowManager.hyprland.extraLuaFiles = {
    host = ./host.lua;
    monitors = {
      content = "return " + lib.generators.toLua { } monitors;
      autoLoad = false;
    };
  };

  # env
  xdg.configFile."uwsm/env-hyprland".text = "export AQ_DRM_DEVICES=/dev/dri/card1";

  # dunst
  services.dunst.settings.global.monitor = monitors.main;

  # hypridle
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
    monitor = monitors.main;
    brightness = 0.4;
  };
}
