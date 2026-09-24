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
      colors = palette // {
        accent = palette.${config.catppuccin.accent};
      };
      hsl = c: "${toString c.hsl.h} ${toString (c.hsl.s * 100)}% ${toString (c.hsl.l * 100)}%";
    in
    lib.mapAttrs (_: c: c.hex) colors // { hsl = lib.mapAttrs (_: hsl) colors; };

}
