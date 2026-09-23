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
    "battery#razermouse" = {
      bat = "hidpp_battery_0";
      format = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰍽</span>{capacity}%";
      format-alt = "{time} {icon}";
      format-charging = "";
      format-full = "";
      format-good = "";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      format-plugged = "";
      states = {
        critical = 15;
        full = 100;
        good = 95;
        warning = 30;
      };
    };
    "battery#razermousecharging" = {
      bat = "hidpp_battery_1";
      format = "";
      format-alt = "{time} {icon}";
      format-charging = " {capacity}%";
      format-full = "";
      format-good = "";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      format-plugged = " {capacity}%";
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
    margin-top = 6;
    modules-right = [
      "group/tray"
      "custom/caffeine"
      "custom/weather"
      "battery#laptop"
      "pulseaudio"
      "privacy"
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
