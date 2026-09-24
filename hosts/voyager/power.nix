{ config, lib, pkgs, ... }:
{
  # scheduler
  services.system76-scheduler.enable = true;
  environment.etc."system76-scheduler/config.kdl".source = lib.mkForce (
    pkgs.runCommand "config.kdl" { } ''
      sed 's/execsnoop true/execsnoop false/' ${config.services.system76-scheduler.package}/data/config.kdl > $out
    ''
  );
}
