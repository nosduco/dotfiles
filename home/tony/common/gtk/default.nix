{
  colors,
  config,
  lib,
  pkgs,
  ...
}:
let
  hex = name: colors.${name};
  semantic = {
    accent_color = "accent";
    accent_bg_color = "accent";
    accent_fg_color = "base";
    destructive_color = "red";
    destructive_bg_color = "red";
    destructive_fg_color = "base";
    success_color = "green";
    success_bg_color = "green";
    success_fg_color = "base";
    warning_color = "yellow";
    warning_bg_color = "yellow";
    warning_fg_color = "base";
    error_color = "red";
    error_bg_color = "red";
    error_fg_color = "base";
    window_bg_color = "base";
    window_fg_color = "text";
    view_bg_color = "base";
    view_fg_color = "text";
    headerbar_bg_color = "mantle";
    headerbar_fg_color = "text";
    sidebar_bg_color = "mantle";
    sidebar_fg_color = "text";
    card_bg_color = "mantle";
    card_fg_color = "text";
    dialog_bg_color = "mantle";
    dialog_fg_color = "text";
    popover_bg_color = "mantle";
    popover_fg_color = "text";
    scrollbar_outline_color = "surface0";
  };
  shades = lib.listToAttrs (
    lib.concatMap
      (
        { name, color }:
        map (i: lib.nameValuePair "${name}_${toString i}" color) (lib.range 1 5)
      )
      [
        {
          name = "blue";
          color = "blue";
        }
        {
          name = "green";
          color = "green";
        }
        {
          name = "yellow";
          color = "yellow";
        }
        {
          name = "orange";
          color = "peach";
        }
        {
          name = "red";
          color = "red";
        }
        {
          name = "purple";
          color = "mauve";
        }
        {
          name = "brown";
          color = "flamingo";
        }
        {
          name = "light";
          color = "text";
        }
        {
          name = "dark";
          color = "crust";
        }
      ]
  );
  defines = lib.concatStrings (
    lib.mapAttrsToList (n: c: "@define-color ${n} ${hex c};\n") (semantic // shades)
  );
  vars = lib.concatStrings (
    lib.mapAttrsToList (n: c: "  --${lib.replaceStrings [ "_" ] [ "-" ] n}: ${hex c};\n") semantic
  );
  icons = pkgs.catppuccin-papirus-folders.override {
    inherit (config.catppuccin.gtk.icon) accent flavor;
  };
  recolor = lib.concatStringsSep " " (
    lib.mapAttrsToList (from: to: "-e 's/${from}/${colors.${to}}/gI'") {
      "#f44336" = "red";
      "#ff9800" = "peach";
      "#4285f4" = "blue";
      "#4caf50" = "green";
    }
  );
in
{
  # icons
  gtk.iconTheme.package = lib.mkForce (
    icons.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        find $out/share/icons \( -path '*/status/*' -o -path '*/panel/*' \) -name '*.svg' -type f \
          -exec chmod u+w {} + \
          -exec sed -i ${recolor} {} +
      '';
    })
  );

  # gtk
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    gtk3.extraCss = defines;
    gtk4.extraCss = defines + ":root {\n" + vars + "}\n";
  };
}
