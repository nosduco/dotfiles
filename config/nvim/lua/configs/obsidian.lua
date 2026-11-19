local M = {}

M.opts = {
  legacy_commands = false,
  workspaces = {
    {
      name = "notes",
      path = "~/notes",
    },
  },
  callbacks = {
    enter_note = function()
      vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", { buffer = true, desc = "Toggle checkbox" })
    end,
  },
  checkbox = {
    order = { " ", "x" },
  },
  templates = {
    folder = "60-Templates",
  },
  daily_notes = {
    folder = "10-Journal",
  },
  notes_subdir = "00-Inbox",
  new_notes_location = "notes_subdir",
  note_id_func = function(title)
    return title
  end,
}

return M
