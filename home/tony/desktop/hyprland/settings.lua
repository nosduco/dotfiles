local c = require("themes.catppuccin")

-- env (NOTE: nixpkgs cap_sys_nice wrapper makes glibc strip TZDIR)
hl.env("TZDIR", "/etc/zoneinfo")

hl.config({
  input = {
    follow_mouse = 2,
    mouse_refocus = false,
  },
  general = {
    gaps_in = 4,
    gaps_out = 10,
    border_size = 2,
    col = {
      active_border = { colors = { c.accent, c.yellow }, angle = 45 },
      inactive_border = c.surface1,
    },
    allow_tearing = true,
  },
  decoration = {
    rounding = 10,
    blur = {
      size = 3,
    },
    shadow = {
      render_power = 4,
    },
  },
  group = {
    col = {
      border_active = { colors = { c.accent, c.yellow }, angle = 45 },
      border_inactive = c.surface1,
    },
    groupbar = {
      font_family = "monospace",
      font_size = 12,
      font_weight_active = "bold",
      font_weight_inactive = "normal",
      height = 22,
      gradients = true,
      gradient_rounding = 10,
      indicator_height = 0,
      gaps_in = 2,
      gaps_out = 4,
      blur = true,
      col = {
        active = "rgba(" .. c.surface1Alpha .. "cc)",
        inactive = "rgba(" .. c.surface0Alpha .. "aa)",
      },
      text_color = c.accent,
      text_color_inactive = c.overlay1,
    },
  },
  cursor = {
    hide_on_key_press = true,
  },
  dwindle = {
    preserve_split = true,
  },
  master = {
    new_status = "master",
  },
  scrolling = {
    focus_fit_method = 0,
  },
  misc = {
    vrr = 2,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    focus_on_activate = true,
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
    allow_session_lock_restore = true,
  },
})
