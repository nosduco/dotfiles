---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  -- Override theme colors
  changed_themes = {
    ayu_dark = {
      base_16 = {
        base0C = "#E95420",
        base0E = "#E95420",
        base0D = "#E95420",
      },
      base_30 = {
        black = "#121212",
        red = "#E95420",
        orange = "#E95420",
        pmenu_bg = "#E95420",
      },
    },
  },

  -- Set theme
  theme = "ayu_dark",

  -- Override highlights
  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

return M
