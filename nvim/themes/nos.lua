local M = {}

M.base_30 = {
  white = "#ced4df",
  black = "#121212", --  nvim bg
  darker_black = "#111111",
  black2 = "#202020",
  one_bg = "#2a2a2a",
  one_bg2 = "#3f3f3f",
  one_bg3 = "#525252",
  grey = "#33363c",
  grey_fg = "#3d4046",
  grey_fg2 = "#46494f",
  light_grey = "#54575d",
  red = "#F07178",
  baby_pink = "#ff949b",
  pink = "#ff8087",
  line = "#24272d", -- for lines like vertsplit
  green = "#AAD84C",
  vibrant_green = "#b9e75b",
  blue = "#36A3D9",
  nord_blue = "#43b0e6",
  yellow = "#E7C547",
  sun = "#f0df8a",
  purple = "#c79bf4",
  dark_purple = "#A37ACC",
  teal = "#74c5aa",
  orange = "#E95420",
  cyan = "#95E6CB",
  statusline_bg = "#2a2a2a",
  lightbg = "#3f3f3f",
  pmenu_bg = "#E95420",
  folder_bg = "#98a3af",
}

M.base_16 = {
  base00 = "#121212",
  base01 = "#2a2a2a",
  base02 = "#3f3f3f",
  base03 = "#525252",
  base04 = "#33363c",
  base05 = "#c9c7be",
  base06 = "#E6E1CF",
  base07 = "#D9D7CE",
  base08 = "#c9c7be",
  base09 = "#FFEE99",
  base0A = "#56c3f9",
  base0B = "#AAD84C",
  base0D = "#F07174",
  base0E = "#E95420",
  base0F = "#CBA6F7",
}

M.polish_hl = {
  luaTSField = { fg = M.base_16.base0D },
  ["@tag.delimiter"] = { fg = M.base_30.cyan },
  ["@function"] = { fg = M.base_30.orange },
  ["@parameter"] = { fg = M.base_16.base0F },
  ["@constructor"] = { fg = M.base_16.base0A },
  ["@tag.attribute"] = { fg = M.base_30.orange },
}

M = require("base46").override_theme(M, "nos")

M.type = "dark"

return M
