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
        ["<C-f>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
        ["<Tab>"] = require("telescope.actions").move_selection_next,
        ["<S-Tab>"] = require("telescope.actions").move_selection_previous,
        ["<C-s>"] = require("telescope.actions").file_vsplit,
        ["<C-i>"] = require("telescope.actions").file_split,
      },
      ["n"] = {
        ["<Tab>"] = require("telescope.actions").move_selection_next,
        ["<S-Tab>"] = require("telescope.actions").move_selection_previous,
        ["<C-f>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
        ["<C-q>"] = require("telescope.actions").close,
        ["<C-s>"] = require("telescope.actions").file_vsplit,
        ["<C-i>"] = require("telescope.actions").file_split,
      },
    },
  },
}

return M
