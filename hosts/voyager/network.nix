{
  config,
  lib,
  pkgs,
  ...
}:
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
      source = lib.getExe (
        pkgs.writeShellApplication {
          name = "exit-node";
          runtimeInputs = [
            pkgs.coreutils
            config.networking.networkmanager.package
            config.services.tailscale.package
          ];
          text = ''
            [ "$2" = up ] && [ -n "''${CONNECTION_UUID:-}" ] || exit 0
            case "$(nmcli -g connection.type connection show "$CONNECTION_UUID")" in
              802-11-wireless | 802-3-ethernet) ;;
              *) exit 0 ;;
            esac
            for _ in $(seq 30); do
              [ -S /var/run/tailscale/tailscaled.sock ] && break
              sleep 1
            done
            if [ "$CONNECTION_UUID" = ${home} ]; then
              tailscale set --exit-node=
            else
              tailscale set --exit-node=auto:any
            fi
          '';
        }
      );
    }
  ];
}
