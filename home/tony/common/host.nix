{ config, lib, ... }:
let
  cfg = config.host;
in
{
  # host
  options.host = {
    vm = lib.mkEnableOption "VM overrides";
    monitors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      apply = m: if cfg.vm then lib.mapAttrs (n: _: if n == "main" then "Virtual-1" else "vm-${n}") m else m;
    };
  };

  config.wayland.windowManager.hyprland.extraLuaFiles.monitors = {
    content = "return " + lib.generators.toLua { } cfg.monitors;
    autoLoad = false;
  };
}
