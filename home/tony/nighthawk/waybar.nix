{ config, ... }:
{
  programs.waybar.settings.main = {
    clock = {
      format = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰙹</span> {:%A, %b %d}";
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
      "battery#mouse"
      "battery#mousecharging"
      "gamemode"
      "pulseaudio"
      "privacy"
      "network"
      "custom/dunst"
      "clock"
    ];
    output = config.host.monitors.main;
    position = "bottom";
  };
}
