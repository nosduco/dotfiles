{
  config,
  lib,
  pkgs,
  ...
}:
let
  monitors = config.host.monitors;
  # TODO: nvidia resume workaround, verify still needed and drop
  dpms-on = pkgs.writeShellApplication {
    name = "dpms-on";
    runtimeInputs = [ pkgs.hyprland ];
    text = ''
      hyprctl dispatch 'hl.dsp.dpms({ action = "enable", monitor = "${monitors.main}" })'
      sleep 1
      hyprctl dispatch 'hl.dsp.dpms({ action = "enable", monitor = "${monitors.top}" })'
      sleep 2
      for _ in 1 2 3; do
        hyprctl dispatch 'hl.dsp.dpms({ action = "enable", monitor = "${monitors.right}" })'
        sleep 1
      done
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
  services.gammastep = {
    latitude = 39.962;
    longitude = -82.996;
  };

  # env
  xdg.configFile."uwsm/env-hyprland".text = "export AQ_DRM_DEVICES=/dev/dri/card0";
  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
    PROTON_ENABLE_NGX_UPDATER = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  # hypridle
  services.hypridle.settings = {
    general.after_sleep_cmd = lib.getExe dpms-on;
    listener = [
      {
        timeout = 600;
        on-timeout = "hyprctl dispatch 'hl.dsp.dpms({ action = \"disable\" })'";
        on-resume = "hyprctl dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
      }
    ];
  };

  # hyprlock
  programs.hyprlock.settings = import ../common/hyprland/hyprlock.nix { monitor = monitors.main; };
}
