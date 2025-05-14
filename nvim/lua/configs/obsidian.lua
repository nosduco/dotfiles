local M = {}

M.opts = {
  workspaces = {
    {
      name = "notes",
      path = "~/notes",
    },
  },
  mappings = {
    ["<leader>ch"] = {
      action = function()
        return require("obsidian").util.toggle_checkbox()
      end,
      opts = { buffer = true },
    },
  },
  templates = {
    subdir = "60-Templates",
  },
  daily_notes = {
    folder = "10-Journal",
    date_format = "%Y-%m-%d",
  },
  notes_subdir = "00-Inbox",
  new_notes_location = "notes_subdir",
  note_id_func = function(title)
    return title
  end,
}

return M
