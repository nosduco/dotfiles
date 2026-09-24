{ pkgs, ... }:
let
  dualsense-init = pkgs.writeShellApplication {
    name = "dualsense-init";
    runtimeInputs = [ pkgs.dualsensectl ];
    text = ''
      shopt -s nullglob
      bound=(/sys/bus/hid/drivers/playstation/*054C:0CE6*)
      [ ''${#bound[@]} -gt 0 ] || exit 0
      sleep 2
      dualsensectl lightbar 255 80 0 255
      dualsensectl player-leds 0
    '';
  };
in
{
  # dualsense
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", RUN+="${pkgs.systemd}/bin/systemd-run --no-block ${dualsense-init}/bin/dualsense-init"
  '';
  systemd.user.services.dualsense-persist = {
    description = "Reapply persistent DualSense lightbar and player LED state";
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${dualsense-init}/bin/dualsense-init";
    };
  };
  systemd.user.timers.dualsense-persist = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "15s";
      OnUnitActiveSec = "30s";
    };
  };
}
