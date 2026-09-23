{ lib, pkgs, ... }:
let
  monitors = import ./monitors.nix;
  # TODO: nvidia resume workaround, verify still needed and drop
  dpms-on = pkgs.writeShellApplication {
    name = "dpms-on";
    runtimeInputs = [ pkgs.hyprland ];
    text = ''
      hyprctl dispatch dpms on ${monitors.main}
      sleep 1
      hyprctl dispatch dpms on ${monitors.top}
      sleep 2
      for _ in 1 2 3; do
        hyprctl dispatch dpms on ${monitors.right}
        sleep 1
      done
    '';
  };
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
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  # hypridle
  services.hypridle.settings = {
    general.after_sleep_cmd = lib.getExe dpms-on;
    listener = [
      {
        timeout = 600;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
    ];
  };

  # hyprlock
  programs.hyprlock.settings = import ../common/hyprland/hyprlock.nix { monitor = monitors.main; };
}
