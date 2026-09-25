{ config, pkgs, ... }:
let
  home = "8e835eaf-7c27-4e83-922d-3a04f07bca83";
in
{
  # tailscale
  services.tailscale.extraSetFlags = [ "--accept-dns=true" ];

  # home wifi
  sops.secrets.wifi-home = { };
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.secrets.wifi-home.path ];
    profiles.nosnet = {
      connection = {
        id = "nosnet";
        uuid = home;
        type = "wifi";
      };
      wifi.ssid = "nosnet";
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "$HOME_WIFI_PSK";
      };
    };
  };

  # exit node
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeShellScript "exit-node" ''
        [ "$2" = up ] || exit 0
        if [ "$CONNECTION_UUID" = ${home} ]; then
          ${config.services.tailscale.package}/bin/tailscale set --exit-node=
        else
          ${config.services.tailscale.package}/bin/tailscale set --exit-node=auto:any
        fi
      '';
    }
  ];
}
