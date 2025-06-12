---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
}

vim.g.remote_sshfs_status_icon = "" -- VS Code-style lock icon
local remote_module = require("remote-sshfs.statusline").nvchad_module {
  highlight = { fg = "#6A9955", bold = true },
}

M.ui = {
  -- Set theme
  transparency = false,

  -- Enable semantic tokens
  -- lsp_semantic_tokens = true,

  -- Cheatsheet
  cheatsheet = {
    theme = "simple",
  },

  -- Statusline
  statusline = {
    theme = "default",
    separator_style = "arrow",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "remote", "lsp", "cwd", "cursor" },
    modules = {
      remote = remote_module,
    },
    -- -- end,
    --   modules[8] = (function()
    --     if rawget(vim, "lsp") then
    --       for _, client in ipairs(vim.lsp.get_active_clients()) do
    --         if client.attached_buffers[vim.api.nvim_get_current_buf()] then
    --           return (vim.o.columns > 100 and "%#St_LspStatus#" .. "   " .. client.name .. " ") or "   LSP "
    --         end
    --       end
    -- end
    -- end
    -- end,
  },

  -- Tabufline
  tabufline = {
    -- overriden_modules = function(modules)
    --   modules[4] = (function()
    --     return ""
    --   end)()
    -- end,
  },
}

-- M.plugins = "custom.plugins"
--
-- M.mappings = require("custom.mappings")

return M
