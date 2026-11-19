{
  config,
  lib,
  osConfig,
  ...
}:
let
  link =
    path:
    config.lib.file.mkOutOfStoreSymlink "${osConfig.programs.nh.flake}/config/streamcontroller/${path}";
  data = ".var/app/com.core447.StreamController/data";
in
{
  # streamcontroller
  home.file = {
    "${data}/pages".source = link "pages";
    "${data}/settings".source = link "settings";
    "${data}/Assets/custom".source = link "Assets/custom";
  };

  # service
  systemd.user.services.streamcontroller = {
    Unit = {
      Description = "StreamController";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe osConfig.programs.streamcontroller.package} -b";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # no xdg autostart
  xdg.configFile."autostart/StreamController.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
