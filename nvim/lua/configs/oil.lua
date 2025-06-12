local M = {}

M.opts = {
  columns = {
    "icon",
--    require("remote-sshfs.filebrowser.oil").column { hl = "DiagnosticHint" },
  },
  keymaps = {
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-i>"] = "actions.select_split",
    ["<C-l>"] = function()
      require("smart-splits").move_cursor_right()
    end,
    ["<C-h>"] = function()
      require("smart-splits").move_cursor_left()
    end,
    ["r"] = "actions.refresh",
    ["p"] = "actions.preview",
    ["x"] = "actions.open_external",
    ["<C-q>"] = "actions.close",
  },
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 9,
  },
  delete_to_trash = true,
}

return M
