{
  config,
  lib,
  osConfig,
  ...
}:
let
  folders = {
    claude = {
      id = "avn4n-hgs9p";
      label = "Claude";
      dir = ".claude";
    };
    edge-workspaces = {
      id = "zxv4y-jwfyp";
      label = "edge-workspaces";
      dir = "work/workspaces";
    };
  };
  ignore = name: ./ignores + "/${name}.stignore";
in
{
  # syncthing
  services.syncthing = {
    enable = true;
    cert = osConfig.sops.secrets.syncthing-cert.path;
    key = osConfig.sops.secrets.syncthing-key.path;
    tray.enable = true;
    settings = {
      devices.tux-hub = {
        id = "LI4KBIR-NDK6NQ2-PHOIWNF-JHSRWZ3-TLZJLMM-PA4CUSJ-IBLU3IN-3C5SUQL";
        addresses = [ "tcp://10.8.40.11:22000" ];
      };
      folders = lib.mapAttrs (_: f: {
        inherit (f) id label;
        path = "${config.home.homeDirectory}/${f.dir}";
        devices = [ "tux-hub" ];
        versioning = {
          type = "trashcan";
          params.cleanoutDays = "0";
        };
      }) folders;
      options = {
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        urAccepted = -1;
      };
    };
  };

  # ignores
  home.file = lib.mapAttrs' (
    name: f: lib.nameValuePair "${f.dir}/.stignore" { source = ignore name; }
  ) (lib.filterAttrs (name: _: builtins.pathExists (ignore name)) folders);
}
