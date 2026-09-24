{ colors, config, ... }:
{
  # dunst
  catppuccin.dunst.enable = false;
  services.dunst = {
    enable = true;
    iconTheme = config.gtk.iconTheme;
    settings = {
      global = {
        font = "sans-serif 10";
        show_age_threshold = -1;
        width = 320;
        height = 500;
        origin = "bottom-right";
        offset = "10x12";
        progress_bar_height = 14;
        frame_width = 2;
        frame_color = colors.accent;
        highlight = colors.accent;
        show_indicators = false;
        line_height = 8;
        separator_height = 3;
        padding = 16;
        horizontal_padding = 12;
        text_icon_padding = 16;
        max_icon_size = 48;
        corner_radius = 10;
      };
      urgency_low = {
        background = colors.base;
        foreground = colors.text;
      };
      urgency_normal = {
        background = colors.base;
        foreground = colors.text;
      };
      urgency_critical = {
        background = colors.base;
        foreground = colors.text;
        frame_color = colors.accent;
      };
    };
  };
}
