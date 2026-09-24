{
  colors,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  aws-vpn = pkgs.writeShellApplication {
    name = "aws-vpn";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      systemctl start awsvpnclient.service
      exec aws-vpn-client-gui "$@"
    '';
  };
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
  imports = [ inputs.awsvpnclient-nix.homeModules.default ];

  # aws vpn
  programs.awsvpnclient = {
    enable = true;
    palette = {
      base00 = colors.base;
      base01 = colors.mantle;
      base02 = colors.surface0;
      base03 = colors.surface1;
      base04 = colors.surface2;
      base05 = colors.text;
      base09 = colors.accent;
      base0B = colors.green;
      base0C = colors.teal;
      base0D = colors.blue;
    };
  };
  xdg.desktopEntries."AWS VPN Client" = {
    name = "AWS VPN Client";
    exec = "${lib.getExe aws-vpn} %U";
    icon = "awsvpnclient";
  };

  # apps
  home.packages = [
    aws-vpn
    mongodb-compass
    pkgs.slack
  ];
}
