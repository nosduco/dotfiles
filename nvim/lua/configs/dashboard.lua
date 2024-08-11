local utils = require "utils"

local M = {}

M.opts = {
  shortcut_type = "number",
  config = {
    shortcut = {
      {
        desc = "󰱼 Find Files",
        group = "@function",
        action = "Telescope find_files",
        key = "f",
      },
      {
        desc = " Todos",
        group = "@comment",
        action = function()
          local path = vim.fn.expand "$HOME" .. "/notes/Todos.md"
          vim.api.nvim_command("edit " .. path)
          local notes_dir = vim.fn.expand "$HOME" .. "/notes/"
          utils.set_cwd(notes_dir)
        end,
        key = "t",
      },
      {
        desc = " Daily Note",
        group = "@type",
        action = function()
          vim.api.nvim_command ":ObsidianToday"
        end,
        key = "N",
      },
      {
        desc = " Note",
        group = "@type",
        action = function()
          local datetime = os.date "%Y-%m-%d-%I-%M%p"
          vim.api.nvim_command(":ObsidianNew " .. datetime)
          -- vim.api.nvim_command ":ObsidianNew"
        end,
        key = "n",
      },
      {
        desc = " Projects",
        group = "@string",
        action = function()
          require("telescope").extensions.file_browser.file_browser {
            path = vim.fn.expand "$HOME" .. "/projects",
            hide_parent_dir = true,
          }
        end,
        key = "p",
      },
      {
        desc = " Work",
        group = "@file",
        action = function()
          require("telescope").extensions.file_browser.file_browser {
            path = vim.fn.expand "$HOME" .. "/work",
            hide_parent_dir = true,
          }
        end,
        key = "w",
      },
      {
        desc = " dotfiles",
        group = "Number",
        action = function()
          require("telescope.builtin").find_files {
            cwd = vim.fn.expand "$HOME" .. "/.dotfiles",
          }
        end,
        key = "d",
      },
      {
        desc = "󰇚 Update",
        group = "@annotation",
        action = function()
          vim.api.nvim_command ":Lazy update"
        end,
        key = "u",
      },
    },
    packages = { enable = false },
    footer = {},
  },
}

M.generate_header = function()
  local header = {
    "",
    " ██╗  ██╗███████╗██╗     ██╗      ██████╗        ████████╗ ██████╗ ███╗   ██╗██╗   ██╗ ",
    " ██║  ██║██╔════╝██║     ██║     ██╔═══██╗       ╚══██╔══╝██╔═══██╗████╗  ██║╚██╗ ██╔╝ ",
    " ███████║█████╗  ██║     ██║     ██║   ██║          ██║   ██║   ██║██╔██╗ ██║ ╚████╔╝  ",
    " ██╔══██║██╔══╝  ██║     ██║     ██║   ██║          ██║   ██║   ██║██║╚██╗██║  ╚██╔╝   ",
    " ██║  ██║███████╗███████╗███████╗╚██████╔╝▄█╗       ██║   ╚██████╔╝██║ ╚████║   ██║    ",
    " ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝       ╚═╝    ╚═════╝ ╚═╝  ╚═══╝   ╚═╝    ",
    "",
  }

  table.insert(header, os.date "%A, %B %e, %Y")
  table.insert(header, "")
  return header
end

return M
