{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  # user dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    desktop = "${home}/desktop";
    documents = "${home}/documents";
    download = "${home}/downloads";
    music = "${home}/music";
    pictures = "${home}/pictures";
    projects = "${home}/projects";
    publicShare = "${home}/public";
    templates = "${home}/templates";
    videos = "${home}/videos";
  };
}
