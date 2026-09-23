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
    exec = "~/.dotfiles/scripts/dunst_tray.sh";
    on-click = "dunstctl set-paused toggle";
    restart-interval = 1;
  };
  "custom/expand-icon" = {
    format = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰅁</span>";
    tooltip = false;
  };
  "custom/media" = {
    escape = true;
    exec = "$HOME/.dotfiles/scripts/mediaplayer.py --player spotify 2> /dev/null";
    format = "{icon}   {}";
    format-icons = {
      default = "🎜";
      spotify = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰓇</span>";
    };
    max-length = 40;
    return-type = "json";
  };
  "custom/vpn" = {
    exec = "$HOME/.dotfiles/scripts/vpn/vpn-status.sh";
    format = "{}";
    interval = 5;
    on-click = "$HOME/.dotfiles/scripts/vpn/vpn-toggle.sh";
    on-click-right = "$HOME/.dotfiles/scripts/vpn/vpn-menu.sh";
    return-type = "json";
  };
  "custom/weather" = {
    exec = "$HOME/.dotfiles/scripts/weather.sh Columbus";
    exec-if = "ping wttr.in -c1";
    format = "{}";
    format-alt = "{alt}: {}";
    format-alt-click = "click-right";
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
  keyboard-state = {
    capslock = true;
    format = "{icon}";
    format-icons = {
      locked = "<span font=\"Material Design Icons\"></span>";
      unlocked = "";
    };
  };
  layer = "top";
  margin-left = 9;
  margin-right = 9;
  modules-center = [ "wlr/taskbar" ];
  modules-left = [
    "hyprland/workspaces"
    "custom/media"
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
}
