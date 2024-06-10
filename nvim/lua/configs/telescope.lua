local M = {}

M.opts = {
  extensions_list = {
    "file_browser",
    "themes",
    "terms",
    "remote-sshfs",
  },
  defaults = {
    mappings = {
      ["i"] = {
        ["<C-q>"] = require("telescope.actions").close,
        ["<Tab>"] = require("telescope.actions").move_selection_next,
        ["<S-Tab>"] = require("telescope.actions").move_selection_previous,
      },
      ["n"] = {
        ["<Tab>"] = require("telescope.actions").move_selection_next,
        ["<S-Tab>"] = require("telescope.actions").move_selection_previous,
        ["<C-q>"] = require("telescope.actions").close,
      },
    },
  },
}

return M
