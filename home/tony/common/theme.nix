{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  # catppuccin
  catppuccin = {
    enable = true;
    autoEnable = true;
    accent = "peach";
    cursors.enable = true;
  };
  _module.args.colors =
    let
      palette =
        (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
        .${config.catppuccin.flavor}.colors;
    in
    lib.mapAttrs (_: c: c.hex) palette // { accent = palette.${config.catppuccin.accent}.hex; };

}
