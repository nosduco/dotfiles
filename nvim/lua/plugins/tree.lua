require("nvim-tree").setup({
  open_on_setup = true,
  view = {
    mappings = {
      list = {
        { key = "s", action = "vsplit" },
        { key = "i", action = "split" },
        { key = "u", actionj = "dir_up" },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  }
})

vim.api.nvim_set_keymap('', '<C-n>', ':NvimTreeToggle<CR>', {})
