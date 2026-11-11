{ config, ... }:
{
  imports = [ ../common ];

  # tide
  tide.contextColor = "green";

  # herdr server
  systemd.user.services.herdr.Install.WantedBy = [ "default.target" ];

  # ovis
  xdg.configFile."herdr/plugins/config/devswha.ovis/env".text = ''
    OVIS_TELEMETRY=0
    DO_NOT_TRACK=1
    OVIS_AUTO_UPDATE=0
    OVIS_TAILSCALE_OWNER=nosduco@gmail.com
  '';

  # sops
  home.sessionVariables.SOPS_AGE_KEY_CMD = "age -d ${config.xdg.configHome}/sops/age/keys.txt.age";
}
