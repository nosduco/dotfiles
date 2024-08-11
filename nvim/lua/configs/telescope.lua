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
        ["<C-s>"] = require("telescope.actions").file_vsplit,
        ["<C-i>"] = require("telescope.actions").file_split,
      },
      ["n"] = {
        ["<Tab>"] = require("telescope.actions").move_selection_next,
        ["<S-Tab>"] = require("telescope.actions").move_selection_previous,
        ["<C-q>"] = require("telescope.actions").close,
        ["<C-s>"] = require("telescope.actions").file_vsplit,
        ["<C-i>"] = require("telescope.actions").file_split,
      },
    },
  },
}

return M
