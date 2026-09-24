{ colors, pkgs, ... }:
{
  # obsidian
  programs.obsidian.enable = true;

  # vesktop
  programs.vesktop = {
    enable = true;
    settings = {
      minimizeToTray = true;
      arRPC = true;
      splashColor = colors.text;
      splashBackground = colors.crust;
      spellCheckLanguages = [
        "en-US"
        "en"
      ];
    };
    vencord.settings.plugins.FakeNitro.enabled = true;
  };

  # element
  programs.element-desktop = {
    enable = true;
    package = pkgs.element-desktop.override { commandLineArgs = "--password-store=gnome-libsecret"; };
    settings.show_labs_settings = true;
  };

  # prismlauncher
  programs.prismlauncher = {
    enable = true;
    settings = {
      ApplicationTheme = "system";
      Language = "en_US";
      IconTheme = "flat";
      BackgroundCat = "rory-flat";
    };
  };

  # media
  programs.mpv.enable = true;

  # office
  programs.libreoffice.enable = true;

  # chromium
  programs.chromium.enable = true;

  # apps
  home.packages = with pkgs; [
    gnome-calendar
    gnome-disk-utility
    mixxx
    multiviewer-for-f1
    planify
    redact
    video-trimmer
  ];
}
