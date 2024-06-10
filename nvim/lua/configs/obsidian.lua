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
    subdir = "Templates",
  },
  daily_notes = {
    folder = "Daily Notes",
    date_format = "%Y-%m-%d",
  },
  notes_subdir = "Scratchpad",
  new_notes_location = "notes_subdir",
  note_id_func = function(title)
    return title
  end,
}

return M
