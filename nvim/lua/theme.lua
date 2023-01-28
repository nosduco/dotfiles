vim.o.background = "dark"

require("catppuccin").setup({
  flavour = "mocha",
  term_colors = true,
  transparent_background = false,
  no_italic = false,
  no_bold = false,
  background = {
    -- dark = "mocha"
  },
  color_overrides = {
    mocha = {
      base = "#262626",
      mantle = "#262626",
      crust = "#262626"
    }
  }
})
vim.cmd([[colorscheme catppuccin]])
