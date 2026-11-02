{ config, lib, ... }:
{
  imports = [ ../common ];

  # tide
  tide.contextColor = "green";

  # herdr server
  systemd.user.services.herdr.Install.WantedBy = [ "default.target" ];

  # herdr integrations
  home.activation.herdrIntegrations = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p $HOME/.codex $HOME/.pi/agent
    for agent in claude codex pi; do
      run ${lib.getExe config.programs.herdr.package} integration install $agent
    done
  '';

  # ovis
  xdg.configFile."herdr/plugins/config/devswha.ovis/env".text = ''
    OVIS_TELEMETRY=0
    DO_NOT_TRACK=1
    OVIS_AUTO_UPDATE=0
  '';
}
