local c = require("themes.catppuccin")

-- env
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
  dwindle = {
    preserve_split = true,
  },
  master = {
    new_status = "master",
  },
  misc = {
    vrr = 2,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    focus_on_activate = true,
  },
})
