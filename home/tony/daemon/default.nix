{
  config,
  osConfig,
  pkgs,
  ...
}:
let
  work-vpn = pkgs.writeShellApplication {
    name = "work-vpn";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.jq
      pkgs.systemd
      osConfig.services.awsvpnclient.cliPackage
    ];
    text = builtins.readFile ./work-vpn.sh;
  };
in
{
  imports = [ ../common ];

  # work vpn
  home.packages = [ work-vpn ];

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
