---@type Base46Table
local M = {}

-- UI
M.base_30 = {
  white = "#E0E0E0",
  black = "#1f1f1f", -- usually your theme bg
  darker_black = "#1A1A1A", -- 6% darker than black
  black2 = "#2A2A2A", -- 6% lighter than black
  one_bg = "#1A1A1A", -- 10% lighter than black
  one_bg2 = "#212121", -- 6% lighter than one_bg2
  one_bg3 = "#242424", -- 6% lighter than one_bg3
  grey = "#727272", -- 40% lighter than black (the % here depends so choose the perfect grey!)
  grey_fg = "#888888", -- 10% lighter than grey
  grey_fg2 = "#7D7D7D", -- 5% lighter than grey
  light_grey = "#EAEAEA",
  red = "#FF7A84",
  baby_pink = "#FF7A84", -- Placeholder, adjust as needed
  pink = "#FF7A84", -- Placeholder, adjust as needed
  line = "#303030", -- 15% lighter than black
  green = "#3a632a", -- Placeholder, adjust as needed
  vibrant_green = "#3a632a", -- Placeholder, adjust as needed
  nord_blue = "#1976D2", -- Placeholder, adjust as needed
  blue = "#1976D2", -- Placeholder, adjust as needed
  seablue = "#1976D2", -- Placeholder, adjust as needed
  yellow = "#f8f8f8", -- 8% lighter than yellow
  sun = "#f8f8f8", -- Placeholder, adjust as needed
  purple = "#b392f0",
  dark_purple = "#b392f0", -- Placeholder, adjust as needed
  teal = "#316bcd", -- Placeholder, adjust as needed
  orange = "#FF9800",
  cyan = "#79b8ff",
  statusline_bg = "#1A1A1A",
  lightbg = "#1A1A1A", -- Placeholder, adjust as needed
  pmenu_bg = "#1A1A1A", -- Placeholder, adjust as needed
  folder_bg = "#1A1A1A" -- Placeholder, adjust as needed
}

-- Base16
M.base_16 = {
  base00 = "#1f1f1f",
  base01 = "#2A2A2A",
  base02 = "#383838",
  base03 = "#444444",
  base04 = "#727272",
  base05 = "#888888",
  base06 = "#E0E0E0",
  base07 = "#FAFAFA",
  base08 = "#FF7A84",
  base09 = "#FF9800",
  base0A = "#f8f8f8",
  base0B = "#3a632a",
  base0C = "#79b8ff",
  base0D = "#1976D2",
  base0E = "#b392f0",
  base0F = "#FF7A84"
}

-- OPTIONAL
-- overriding highlights for this specific theme only 
M.polish_hl = {
  Comment = {
    bg = M.base_30.black,
    fg = "#6b737c",
    italic = true
  }
}

-- set the theme type whether is dark or light
M.type = "dark"

-- this will be later used for users to override your theme table from chadrc
M = require("base46").override_theme(M, "min_dark")

return M
