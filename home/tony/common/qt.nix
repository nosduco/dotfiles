{ config, ... }:
let
  qtct = {
    Appearance = {
      style = "Fusion";
      icon_theme = config.gtk.iconTheme.name;
      standard_dialogs = "xdgdesktopportal";
    };
    Fonts = {
      general = ''"sans-serif,11"'';
      fixed = ''"monospace,11"'';
    };
  };
in
{
  # qt
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt5ctSettings = qtct;
    qt6ctSettings = qtct;
  };
  catppuccin.qt5ct.enable = true;
  catppuccin.kvantum.enable = false;
}
