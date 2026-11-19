{ config, icon, ... }:
{
  programs.waybar.settings.main = {
    clock = {
      format = "${icon "󰙹"} {:%A, %b %d}";
    };
    margin-bottom = 6;
    modules-right = [
      "group/tray"
      "custom/recording"
      "custom/caffeine"
      "custom/nightlight"
      "custom/weather"
      "battery#mouse"
      "battery#mousecharging"
      "pulseaudio"
      "privacy"
      "bluetooth"
      "network"
      "custom/dunst"
      "clock"
    ];
    output = config.host.monitors.main;
    position = "bottom";
  };
}
