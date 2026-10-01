{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  monitors = config.host.monitors;
  low-battery-suspend = pkgs.writeShellApplication {
    name = "low-battery-suspend";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      if ! systemd-ac-power && [ "$(</sys/class/power_supply/BAT0/capacity)" -le ${toString osConfig.services.upower.percentageLow} ]; then
        systemctl suspend
      fi
    '';
  };
in
{
  # hyprland
  host.monitors = import ./monitors.nix;
  wayland.windowManager.hyprland.extraLuaFiles = {
    host = ./host.lua;
  };

  # night light
  services.gammastep.provider = "geoclue2";

  # env
  xdg.configFile."uwsm/env-hyprland".text = "export AQ_DRM_DEVICES=/dev/dri/card1";

  # swayosd
  xdg.configFile."swayosd/config.toml".source = (pkgs.formats.toml { }).generate "swayosd-config" {
    server.max_volume = 200;
  };

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
        timeout = 300;
        on-timeout = lib.getExe low-battery-suspend;
      }
      {
        timeout = 1800;
        on-timeout = "systemctl suspend";
      }
    ];
  };

  # battery alerts
  services.poweralertd.enable = true;

  # hyprlock
  programs.hyprlock.settings = import ../common/hyprland/hyprlock.nix {
    monitor = "";
    brightness = 0.4;
  };
}
