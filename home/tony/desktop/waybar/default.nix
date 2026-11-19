{
  colors,
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  flatIcon =
    glyph: "<span font=\"Material Design Icons\" size='large' font_weight='normal'>${glyph}</span>";
  icon =
    glyph:
    "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>${glyph}</span>";
  caffeine = pkgs.writeShellApplication {
    name = "waybar-caffeine";
    runtimeInputs = with pkgs; [
      coreutils
      jq
      libnotify
      procps
      systemd
    ];
    runtimeEnv = lib.optionalAttrs osConfig.services.upower.enable {
      LOW = toString osConfig.services.upower.percentageLow;
    };
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
  nightlight = pkgs.writeShellApplication {
    name = "waybar-nightlight";
    runtimeInputs = with pkgs; [
      coreutils
      systemd
    ];
    text = builtins.readFile ./nightlight.sh;
  };
in
{
  # waybar
  _module.args = { inherit flatIcon icon; };
  catppuccin.waybar.mode = "createLink";
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      @import "catppuccin.css";
      @define-color accent @${config.catppuccin.accent};

      ${builtins.readFile ./style.css}
    '';
    settings.main =
      lib.recursiveUpdate
        (import ./settings.nix {
          inherit colors flatIcon icon;
          iconTheme = config.gtk.iconTheme.name;
        })
        {
          "custom/dunst".exec = lib.getExe dunst-tray;
          "custom/weather".exec =
            "${lib.getExe pkgs.wttrbar} --location Columbus --fahrenheit --ampm --nerd --custom-indicator '{ICON} {temp_F}°'";
        };
  };
  home.packages = [
    caffeine
    nightlight
  ];

  # restart on change
  systemd.user.services.waybar.Unit = {
    X-Reload-Triggers = lib.mkForce [ ];
    X-Restart-Triggers = [
      "${config.xdg.configFile."waybar/config".source}"
      "${config.xdg.configFile."waybar/style.css".source}"
    ];
  };

  # night light
  xdg.configFile."gammastep/hooks/waybar".source = lib.getExe nightlight;
}
