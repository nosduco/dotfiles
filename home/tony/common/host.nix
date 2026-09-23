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
      apply = m: if cfg.vm then lib.mapAttrs (_: _: "Virtual-1") m else m;
    };
  };

  config.wayland.windowManager.hyprland.extraLuaFiles.monitors = {
    content = "return " + lib.generators.toLua { } cfg.monitors;
    autoLoad = false;
  };
}
