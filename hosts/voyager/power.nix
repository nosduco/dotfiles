{ config, lib, pkgs, ... }:
{
  # scheduler
  services.system76-scheduler.enable = true;
  environment.etc."system76-scheduler/config.kdl".source = lib.mkForce (
    pkgs.runCommand "config.kdl" { } ''
      sed 's/execsnoop true/execsnoop false/' ${config.services.system76-scheduler.package}/data/config.kdl > $out
    ''
  );

  # updates on battery
  systemd.services.comin-power = {
    after = [ "comin.service" ];
    wantedBy = [ "comin.service" ];
    path = [
      config.services.comin.package
      config.systemd.package
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      until comin status >/dev/null 2>&1; do sleep 2; done
      if systemd-ac-power; then comin resume; else comin suspend; fi || true
    '';
  };
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${config.systemd.package}/bin/systemctl start --no-block comin-power.service"
  '';
}
