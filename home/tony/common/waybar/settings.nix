{
  clock = {
    actions = {
      on-click-backward = "tz_down";
      on-click-forward = "tz_up";
      on-click-right = "mode";
      on-scroll-down = "shift_down";
      on-scroll-up = "shift_up";
    };
    calendar = {
      format = {
        days = "<span color='#ecc6d9'><b>{}</b></span>";
        months = "<span color='#ffead3'><b>{}</b></span>";
        today = "<span color='#ff6699'><b><u>{}</u></b></span>";
        weekdays = "<span color='#ffcc66'><b>{}</b></span>";
        weeks = "<span color='#99ffdd'><b>W{}</b></span>";
      };
      mode = "month";
      mode-mon-col = 3;
      on-click-right = "mode";
      on-scroll = 1;
    };
    on-click = "xdg-open https://calendar.google.com";
    tooltip-format = "<tt><small>{calendar}</small></tt>";
  };
  "battery#mouse" = {
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
  "battery#mousecharging" = {
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
  "custom/caffeine" = {
    exec = "waybar-caffeine status";
    format = "{icon}";
    format-icons = {
      activated = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰅶</span>";
      deactivated = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰾫</span>";
    };
    interval = "once";
    on-click = "waybar-caffeine toggle";
    return-type = "json";
    signal = 8;
  };
  "custom/dunst" = {
    on-click = "dunstctl set-paused toggle";
    restart-interval = 1;
  };
  "custom/expand-icon" = {
    format = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰅁</span>";
    tooltip = false;
  };
  mpris = {
    player = "spotify";
    format = "{player_icon}   {dynamic}";
    format-paused = "{player_icon}   <i>{dynamic}</i>";
    player-icons = {
      default = "🎜";
      spotify = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰓇</span>";
    };
    max-length = 40;
  };
  "custom/weather" = {
    format = "{}";
    interval = 1800;
    return-type = "json";
  };
  "group/tray" = {
    drawer = {
      children-class = "tray-group-item";
      transition-duration = 600;
    };
    modules = [
      "custom/expand-icon"
      "tray"
    ];
    orientation = "inherit";
  };
  gtk-layer-shell = true;
  height = 32;
  "hyprland/workspaces" = {
    format = "{icon}";
    format-icons = {
      active = "";
      default = "";
    };
    on-click = "activate";
    persistent-only = true;
    persistent-workspaces = {
      "1" = [ ];
      "2" = [ ];
      "3" = [ ];
      "4" = [ ];
    };
  };
  layer = "top";
  margin-left = 9;
  margin-right = 9;
  modules-center = [ "wlr/taskbar" ];
  modules-left = [
    "hyprland/workspaces"
    "mpris"
  ];
  network = {
    format-disconnected = "Disconnected ⚠";
    format-ethernet = "<span font=\"Material Design Icons\" size='large' font_weight='normal'>󰈀</span>";
    format-wifi = "<span font=\"Material Design Icons\" size='large' font_weight='normal'>󰖩</span>";
    tooltip-format = "{gwaddr} via {ifname}";
  };
  spacing = 8;
  tray = {
    icon-size = 16;
    spacing = 8;
  };
  "wlr/taskbar" = {
    all-outputs = true;
    app_ids-mapping = {
      firefoxdeveloperedition = "firefox-developer-edition";
    };
    format = "{icon}";
    icon-size = 24;
    icon-theme = "Papirus-Dark";
    on-click = "activate";
    on-click-middle = "close";
    rewrite = {
      "Firefox Web Browser" = "Firefox";
      "Foot Server" = "Terminal";
    };
    tooltip-format = "{title}";
  };
  pulseaudio = {
    format = "{icon} {format_source}";
    format-icons = {
      headphone = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰋋</span>";
      speaker = [
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰕿</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰖀</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰕾</span>"
      ];
      default = [
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰕿</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰖀</span>"
        "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰕾</span>"
      ];
    };
    format-muted = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰝟</span> {format_source}";
    format-source = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰍬</span>";
    format-source-muted = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰍭</span>";
    on-click = "ghostty --title=wiremix -e wiremix";
    on-click-right = "helvum";
    tooltip-format = "{desc}: {volume}%";
  };
}
