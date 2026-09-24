{ config, osConfig, ... }:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${osConfig.programs.nh.flake}/config/streamcontroller/${path}";
  data = ".var/app/com.core447.StreamController/data";
in
{
  # streamcontroller
  home.file = {
    "${data}/pages".source = link "pages";
    "${data}/settings".source = link "settings";
    "${data}/Assets/custom".source = link "Assets/custom";
  };
}
