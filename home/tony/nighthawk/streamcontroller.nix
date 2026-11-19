{
  colors,
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
  assets = ../../../config/streamcontroller/Assets/custom;
  palette = lib.filterAttrs (_: builtins.isString) colors;
  paint = builtins.replaceStrings (map (c: "@${c}@") (builtins.attrNames palette)) (
    builtins.attrValues palette
  );
  icon =
    name:
    if lib.hasSuffix ".svg" name then
      { text = paint (builtins.readFile (assets + "/${name}")); }
    else
      { source = assets + "/${name}"; };
in
{
  # streamcontroller
  home.file = {
    "${data}/pages".source = link "pages";
    "${data}/settings".source = link "settings";
  }
  // lib.mapAttrs' (name: _: lib.nameValuePair "${data}/Assets/custom/${name}" (icon name)) (
    builtins.readDir assets
  );

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
