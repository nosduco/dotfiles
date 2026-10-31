{ colors, pkgs, ... }:
{
  # wiremix
  programs.wiremix = {
    enable = true;
    settings = {
      theme = "catppuccin";
      themes.catppuccin = {
        selector.fg = colors.accent;
        tab_selected.fg = colors.accent;
        tab_marker.fg = colors.accent;
        list_more.fg = colors.overlay0;
        volume_empty.fg = colors.surface1;
        volume_filled.fg = colors.accent;
        meter_inactive.fg = colors.surface1;
        meter_active.fg = colors.green;
        meter_overload.fg = colors.red;
        meter_center_inactive.fg = colors.surface1;
        meter_center_active.fg = colors.green;
        dropdown_selected = {
          fg = colors.accent;
          add_modifier = "REVERSED";
        };
        dropdown_more.fg = colors.overlay0;
        help_more.fg = colors.overlay0;
      };
    };
  };

  # helvum
  home.packages = [ pkgs.helvum ];
}
