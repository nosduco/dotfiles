{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
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
  scan = pkgs.writeShellApplication {
    name = "scan";
    runtimeInputs = with pkgs; [
      grimblast
      libnotify
      tesseract
      wl-clipboard
      zbar
    ];
    text = builtins.readFile ./scan.sh;
  };
  share = pkgs.writeShellApplication {
    name = "share";
    runtimeInputs = with pkgs; [
      coreutils
      ffmpeg
      libnotify
      wl-clipboard
    ];
    text = builtins.readFile ./share.sh;
  };
  record = pkgs.writeShellApplication {
    name = "record";
    runtimeInputs = with pkgs; [
      osConfig.programs.gpu-screen-recorder.package
      coreutils
      curl
      jq
      libnotify
      losslesscut-bin
      systemd
      xdg-user-dirs
    ];
    runtimeEnv.SHARE = "${pkgs.writeShellScript "record-share" ''
      exec ${pkgs.systemd}/bin/systemd-run --user --scope -q ${lib.getExe share} "$1"
    ''}";
    text = builtins.readFile ./record.sh;
  };
  keybinds = pkgs.writeShellApplication {
    name = "keybinds";
    runtimeInputs = [ pkgs.jq ];
    text = builtins.readFile ./keybinds.sh;
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
      osd = {
        content = ./osd.lua;
        autoLoad = false;
      };
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
    scan
    share
    record
    keybinds
    pkgs.grimblast
  ];

  # hyprlock
  programs.hyprlock = {
    enable = true;
    package = null;
  };
  catppuccin.hyprlock.useDefaultConfig = false;
}
