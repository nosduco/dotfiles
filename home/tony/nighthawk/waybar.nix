{ config, ... }:
{
  programs.waybar.settings.main = {
    clock = {
      format = "<span font=\"Material Design Icons\" size='large' font_weight='normal' rise='-1500'>󰙹</span> {:%A, %b %d}";
    };
    margin-bottom = 6;
    modules-right = [
      "group/tray"
      "custom/caffeine"
      "custom/weather"
      "battery#mouse"
      "battery#mousecharging"
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
