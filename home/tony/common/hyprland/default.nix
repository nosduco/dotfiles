{ config, pkgs, ... }:
let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      grimblast
      satty
      wl-clipboard
      procps
      xdg-user-dirs
    ];
    text = builtins.readFile ./screenshot.sh;
  };
in
{
  # hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    extraLuaFiles = {
      settings = ./settings.lua;
      animations = ./animations.lua;
      rules = ./rules.lua;
      autostart = ./autostart.lua;
      binds = ./binds.lua;
      session = {
        content = ./session.lua;
        autoLoad = false;
      };
    };
  };

  # env
  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  # cursor
  home.pointerCursor = {
    enable = true;
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  # session
  services.hyprpolkitagent.enable = true;

  # hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "pidof hyprlock || hyprlock --grace 3";
        }
      ];
    };
  };

  # night light
  services.gammastep = {
    enable = true;
    temperature = {
      day = 6500;
      night = 4500;
    };
  };

  # hyprpaper
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${config.xdg.userDirs.pictures}/wallpapers";
          order = "random";
          timeout = 3600;
        }
      ];
    };
  };

  # screenshot
  home.packages = [
    screenshot
    pkgs.grimblast
  ];

  # hyprlock
  programs.hyprlock = {
    enable = true;
    package = null;
  };
  catppuccin.hyprlock.useDefaultConfig = false;
}
