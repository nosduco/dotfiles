{
  config,
  lib,
  pkgs,
  ...
}:
let
  fm1 = pkgs.org-freedesktop-filemanager1-common;
  fm1Exec = "${fm1}/libexec/file_manager_dbus";
in
{
  # nautilus
  home.packages = with pkgs; [
    nautilus
    hyprpicker
  ];
  programs.fish.shellAliases.fsi = "nautilus . &";
  gtk.gtk3.bookmarks = [
    "file://${config.home.homeDirectory}/projects projects"
    "file://${config.xdg.userDirs.download} downloads"
  ];

  # file chooser
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    env=TERMCMD=ghostty --title=FileChooser -e
  '';

  # file manager
  xdg.configFile."org.freedesktop.FileManager1.common/config".text = ''
    cmd=${fm1}/share/org.freedesktop.FileManager1.common/yazi-wrapper.sh
  '';
  systemd.user.services.filemanager1 = {
    Unit = {
      Description = "FileManager1 D-Bus service (yazi)";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.FileManager1";
      ExecStart = fm1Exec;
      Environment = "\"TERMCMD=ghostty --title=FileManager -e env\"";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
  xdg.dataFile."dbus-1/services/org.freedesktop.FileManager1.service".text = ''
    [D-BUS Service]
    Name=org.freedesktop.FileManager1
    Exec=${fm1Exec}
    SystemdService=filemanager1.service
  '';
}
