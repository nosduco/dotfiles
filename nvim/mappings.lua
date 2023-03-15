---@type MappingsTable
local M = {}

M.general = {
  n = {
    -- Shortcut to command
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.comment = {
  -- Toggle comment in both modes
    n = {
    ["<C-_>"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  v = {
    ["<C-_>"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

M.telescope = {
  -- Quick-display telescope
  n = {
    ["<C-space>"] = { "<cmd> Telescope find_files <CR>", "find files" },
  }
}

M.nvterm = {
  t = {
    -- Toggle veritcal terminal
    ["<C-t>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "toggle vertical term",
    },
  },
  n = {
    -- Toggle veritcal terminal
    ["<C-t>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "toggle vertical term",
    },
  }
}

M.lspconfig = {
  n = {
    -- Autoformat via lsp
    ["<C-F>"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "lsp formatting",
    },
  }
}

-- more keybinds!

return M
