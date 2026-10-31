{ config, lib, ... }:
{
  imports = [ ../common ];

  # tide
  tide.contextColor = "green";

  # herdr server
  systemd.user.services.herdr = {
    Unit = {
      Description = "herdr server";
      X-SwitchMethod = "keep-old";
    };
    Service = {
      ExecStart = "${lib.getExe config.programs.herdr.package} server";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # ovis
  xdg.configFile."herdr/plugins/config/devswha.ovis/env".text = ''
    OVIS_TELEMETRY=0
    DO_NOT_TRACK=1
    OVIS_AUTO_UPDATE=0
  '';
}
