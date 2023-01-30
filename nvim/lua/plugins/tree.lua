-- Setup tree/file browser
require("nvim-tree").setup({
  open_on_setup = true,
  view = {
    adaptive_size = true,
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
      window_picker = {
        enable = false,
      }
    },
  },

})

-- Set ctrl+n keybind to open tree
vim.api.nvim_set_keymap('', '<C-n>', ':NvimTreeToggle<CR>', {})
