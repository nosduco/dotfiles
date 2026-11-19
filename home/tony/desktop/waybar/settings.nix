{
  colors,
  flatIcon,
  icon,
  iconTheme,
}:
{
  bluetooth = {
    format = flatIcon "󰂯";
    format-connected = flatIcon "󰂱";
    format-disabled = flatIcon "󰂲";
    format-no-controller = "";
    format-off = flatIcon "󰂲";
    on-click = "ghostty --title=bluetui -e bluetui";
    tooltip-format = "{status}";
    tooltip-format-connected = "{num_connections} connected";
  };
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
        days = "<span color='${colors.flamingo}'><b>{}</b></span>";
        months = "<span color='${colors.rosewater}'><b>{}</b></span>";
        today = "<span color='${colors.accent}'><b><u>{}</u></b></span>";
        weekdays = "<span color='${colors.yellow}'><b>{}</b></span>";
        weeks = "<span color='${colors.teal}'><b>W{}</b></span>";
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
    format = "${icon "󰍽"}{capacity}%";
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
      activated = icon "󰅶";
      deactivated = icon "󰾫";
    };
    interval = 5;
    on-click = "waybar-caffeine toggle";
    return-type = "json";
    signal = 8;
  };
  "custom/nightlight" = {
    exec = "waybar-nightlight status";
    format = "{icon}";
    format-icons = {
      on = icon "󰖔";
      off = icon "󰖙";
    };
    interval = "once";
    on-click = "waybar-nightlight toggle";
    return-type = "json";
    signal = 9;
  };
  "custom/recording" = {
    exec = "record status";
    format = "{icon}";
    format-icons = {
      recording = icon "󰑋";
      replay = icon "󰑙";
    };
    interval = "once";
    on-click = "record stop";
    return-type = "json";
    signal = 10;
  };
  "custom/dunst" = {
    on-click = "dunstctl set-paused toggle";
    restart-interval = 1;
  };
  "custom/expand-icon" = {
    format = icon "󰅁";
    tooltip = false;
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
  modules-left = [ "hyprland/workspaces" ];
  network = {
    format-disconnected = "Disconnected ⚠";
    format-ethernet = flatIcon "󰈀";
    format-wifi = flatIcon "󰖩";
    tooltip-format = "{gwaddr} via {ifname}";
  };
  spacing = 8;
  tray = {
    icon-size = 16;
    spacing = 8;
  };
  "wlr/taskbar" = {
    all-outputs = true;
    format = "{icon}";
    icon-size = 24;
    icon-theme = iconTheme;
    on-click = "activate";
    on-click-middle = "close";
    rewrite = {
      "Firefox Web Browser" = "Firefox";
    };
    tooltip-format = "{title}";
  };
  pulseaudio = {
    format = "{icon}{format_source}";
    format-icons = {
      headphone = icon "󰋋";
      speaker = [
        (icon "󰕿")
        (icon "󰖀")
        (icon "󰕾")
      ];
      default = [
        (icon "󰕿")
        (icon "󰖀")
        (icon "󰕾")
      ];
    };
    format-muted = "${icon "󰝟"}{format_source}";
    format-source = "";
    format-source-muted = " ${icon "󰍭"}";
    on-click = "ghostty --title=wiremix -e wiremix";
    on-click-right = "helvum";
    tooltip-format = "{desc}: {volume}%";
  };
}
