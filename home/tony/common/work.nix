{ pkgs, ... }:
let
  mongodb-compass = pkgs.symlinkJoin {
    name = "mongodb-compass";
    paths = [ pkgs.mongodb-compass ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/mongodb-compass \
        --set XDG_SESSION_TYPE x11 \
        --set MONGODB_COMPASS_TEST_LOG_DIR /dev/null \
        --set XDG_CURRENT_DESKTOP GNOME
    '';
  };
in
{
  # apps
  home.packages = [
    mongodb-compass
    pkgs.slack
  ];
}
