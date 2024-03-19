---@type ChadrcConfig
local M = {}

M.ui = {
  -- Set theme
  theme = "ayu_dark",

  -- Enable semantic tokens
  lsp_semantic_tokens = true,

  -- Cheatsheet
  cheatsheet = {
    theme = "simple",
  },

  -- Statusline
  statusline = {
    theme = "default",
    separator_style = "arrow",
    overriden_modules = function(modules)
      modules[8] = (function()
        if rawget(vim, "lsp") then
          for _, client in ipairs(vim.lsp.get_active_clients()) do
            if client.attached_buffers[vim.api.nvim_get_current_buf()] then
              return (vim.o.columns > 100 and "%#St_LspStatus#" .. "   " .. client.name .. " ") or "   LSP "
            end
          end
        end
      end)()
    end,
  },

  -- Tabufline
  tabufline = {
    overriden_modules = function(modules)
      modules[4] = (function()
        return ""
      end)()
    end,
  },
}

-- M.plugins = "custom.plugins"
--
-- M.mappings = require("custom.mappings")

return M
