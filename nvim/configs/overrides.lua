local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "scss",
    "dockerfile",
    "go",
    "gomod",
    "json",
    "jsdoc",
    "make",
    "prisma",
    "python",
    "regex",
    "sql",
    "terraform",
    "toml",
    "yaml",
    "javascript",
    "typescript",
    "markdown",
    "markdown_inline",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = {
      "python"
    },
  },
}

M.mason = {
  ensure_installed = {
    -- Lua
    "lua-language-server",
    "stylua",

    -- Web
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "s", action = "vsplit" },
        { key = "i", action = "split" },
        { key = "u", action = "dir_up" },
      }
    }
  },
  actions = {
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false,
      }
    },
  },
}

return M