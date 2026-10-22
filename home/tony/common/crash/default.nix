{ lib, pkgs, ... }:
let
  crash-watch = pkgs.writeShellApplication {
    name = "crash-watch";
    runtimeInputs = with pkgs; [
      coreutils
      jq
      libnotify
      systemd
    ];
    text = builtins.readFile ./crash-watch.sh;
  };
in
{
  # crash watch
  systemd.user.services.crash-watch = {
    Unit = {
      Description = "crash notifications";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe crash-watch;
      Restart = "always";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # debugging
  home.packages = [ pkgs.gdb ];
}
