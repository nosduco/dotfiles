local theme = require('lualine.themes.ayu')

-- Override ayu lualine theme
local panel_border = "#262626"
local normal_bg = "#E95420"
local fg = "#626262"

-- Replace panel border colors
theme.visual.b.bg = panel_border
theme.replace.b.bg = panel_border
theme.inactive.a.bg = panel_border
theme.inactive.b.bg = panel_border
theme.inactive.c.bg = panel_border
theme.normal.b.bg = panel_border
theme.normal.c.bg = panel_border
theme.insert.b.bg = panel_border

-- Replace background color
theme.normal.a.bg = normal_bg

-- Replace foreground color
theme.replace.a.fg = fg
theme.insert.b.fg = fg
theme.normal.c.fg = fg
theme.normal.b.fg = fg
theme.visual.b.fg = fg
theme.inactive.a.fg = fg
theme.inactive.b.fg = fg
theme.inactive.c.fg = fg

-- Setup lualine
require('lualine').setup({
  options = {
    theme = theme
  }
})
