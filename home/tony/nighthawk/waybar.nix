let
  monitors = import ./monitors.nix;
in
{
  programs.waybar.settings.main = {
    battery = {
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
    "battery#charging" = {
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
      format = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰙹</span> {:%A, %b %d}";
    };
    "custom/voxtype" = {
      exec = "voxtype status --follow --format json";
      format = "{}";
      on-click = "systemctl --user restart voxtype";
      return-type = "json";
      tooltip = true;
    };
    gamemode = {
      format-alt = "{glyph} {count}";
      glyph = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰊴</span>";
      hide-not-running = true;
      icon-name = "input-gaming-symbolic";
      icon-size = 20;
      icon-spacing = 4;
      tooltip-format = "Games running: {count}";
      use-icon = true;
    };
    margin-bottom = 6;
    modules-right = [
      "group/tray"
      "custom/caffeine"
      "custom/weather"
      "battery"
      "battery#charging"
      "gamemode"
      "pulseaudio"
      "privacy"
      "custom/vpn"
      "custom/voxtype"
      "network"
      "custom/dunst"
      "clock"
    ];
    output = monitors.main;
    position = "bottom";
    pulseaudio = {
      format = "{icon} {format_source}";
      format-icons = {
        headphone = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰋋</span>";
        speaker = [
          "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰕿</span>"
          "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰖀</span>"
          "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰕾</span>"
        ];
      };
      format-muted = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰝟</span> {format_source}";
      on-click = "pavucontrol";
      on-click-right = "helvum";
    };
  };
}
