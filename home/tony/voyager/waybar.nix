{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  vpn = pkgs.writeShellApplication {
    name = "waybar-vpn";
    runtimeInputs = [
      pkgs.gnugrep
      pkgs.jq
      pkgs.procps
      osConfig.networking.networkmanager.package
      osConfig.services.tailscale.package
    ];
    runtimeEnv.HOME_UUID = osConfig.networking.networkmanager.ensureProfiles.profiles.nosnet.connection.uuid;
    text = builtins.readFile ./vpn.sh;
  };
in
{
  programs.waybar.settings.main = {
    "battery#laptop" = {
      bat = "BAT0";
      format = "{icon}";
      format-charging = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰂄</span> {capacity}%";
      format-icons = [
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰁺</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰁻</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰁼</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰁽</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰁾</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰁿</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰂀</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰂁</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰂂</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰁹</span>"
      ];
      format-plugged = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰂄</span> {capacity}%";
      interval = 60;
      states = {
        critical = 15;
        full = 100;
        good = 95;
        warning = 30;
      };
    };
    clock = {
      format = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰙹</span> {:%A, %b %d %I:%M %p}";
    };
    "custom/vpn" = {
      exec = "${lib.getExe vpn} status";
      format = "{icon}";
      format-icons = {
        on = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰦝</span>";
        home = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰳋</span>";
        exposed = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰻍</span>";
      };
      interval = 5;
      on-click = "${lib.getExe vpn} toggle";
      return-type = "json";
      signal = 9;
    };
    margin-top = 6;
    modules-right = [
      "group/tray"
      "custom/recording"
      "custom/caffeine"
      "custom/nightlight"
      "custom/weather"
      "battery#laptop"
      "pulseaudio"
      "privacy"
      "custom/vpn"
      "bluetooth"
      "network"
      "custom/dunst"
      "clock"
    ];
    network = {
      format-alt = "󰈀 {ipaddr}/{cidr}";
      format-linked = "{ifname} (No IP) 󰈀";
      tooltip-format-wifi = "{essid} ({signalStrength}%)";
    };
    position = "top";
  };
}
