{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  ntfy-notify = pkgs.writeShellApplication {
    name = "ntfy-notify";
    runtimeInputs = with pkgs; [
      coreutils
      curl
      findutils
      jq
      libnotify
      xdg-utils
    ];
    text = builtins.readFile ./ntfy-notify.sh;
  };
  ntfy-watch = pkgs.writeShellApplication {
    name = "ntfy-watch";
    runtimeInputs = with pkgs; [
      coreutils
      ntfy-sh
    ];
    text = ''
      NTFY_TOKEN=$(cat ${osConfig.sops.secrets.ntfy-token.path})
      export NTFY_TOKEN
      exec ntfy subscribe https://ntfy.tuxcloud.xyz/alerts-critical,home-assistant ${lib.getExe ntfy-notify}
    '';
  };
in
{
  # ntfy
  systemd.user.services.ntfy-watch = {
    Unit = {
      Description = "ntfy notifications";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe ntfy-watch;
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
