local dashboard = require "configs.dashboard"
local remotesshfs = require "configs.remote-sshfs"
local treesitter = require "configs.treesitter"
local mason = require "configs.mason"
local colorizer = require "configs.colorizer"
local oil = require "configs.oil"
local obsidian = require "configs.obsidian"

return {
  -- Core
  "nvim-lua/plenary.nvim",

  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      integrations = {
        blink_cmp = true,
        dashboard = true,
        diffview = true,
        flash = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        mason = true,
        native_lsp = { enabled = true },
        nvim_surround = true,
        snacks = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function lsp_name()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        if #clients == 0 then
          return ""
        end
        return "  " .. clients[1].name
      end

      local function cwd()
        local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return "󰉋 " .. dir
      end

      -- Custom theme with peach accent
      local C = require("catppuccin.palettes").get_palette "mocha"
      local custom_theme = require("lualine.themes.catppuccin-mocha")
      custom_theme.normal.a = { bg = C.peach, fg = C.base, gui = "bold" }
      custom_theme.normal.b = { bg = C.surface0, fg = C.text }
      custom_theme.normal.c = { bg = C.base, fg = C.text }

      require("lualine").setup {
        options = {
          theme = custom_theme,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "filename", path = 0 } },
          lualine_c = { "branch", "diff" },
          lualine_x = { "diagnostics", lsp_name },
          lualine_y = { cwd },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    config = function()
      local C = require("catppuccin.palettes").get_palette "mocha"
      local hl = require("catppuccin.special.bufferline").get_theme()()
      hl.fill = { bg = C.mantle }

      require("bufferline").setup {
        options = {
          close_command = "bdelete! %d",
          diagnostics = "nvim_lsp",
          separator_style = "thin",
          offsets = {},
          themable = true,
        },
        highlights = hl,
      }
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
      },
    },
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = {},
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { char = "│" },
    },
    config = function(_, opts)
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)
    end,
  },

  -- Devicons
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "mfussenegger/nvim-lint",
        config = function()
          require "configs.lint"
        end,
      },
      {
        "stevearc/conform.nvim",
        config = function()
          require "configs.conform"
        end,
      },
      {
        "mfussenegger/nvim-jdtls",
      },
    },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdLineEnter" },

    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          -- Snippet loaders (previously from nvchad.configs.luasnip)
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_snipmate").load()
          require("luasnip.loaders.from_lua").load()
        end,
      },
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "snacks_picker_input", "vim" },
        },
      },
      {
        "Exafunction/codeium.nvim",
      },
    },

    opts_extend = { "sources.default" },

    opts = {
      snippets = { preset = "luasnip" },
      cmdline = { enabled = true },
      appearance = { nerd_font_variant = "normal" },
      fuzzy = { implementation = "prefer_rust" },

      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "single" },
        },
        menu = {
          scrollbar = false,
          border = "single",
          draw = {
            padding = { 1, 1 },
            columns = { { "label" }, { "kind_icon" }, { "kind" } },
          },
        },
      },

      sources = {
        default = { "lsp", "snippets", "buffer", "path", "codeium" },
        providers = {
          codeium = {
            name = "Codeium",
            module = "codeium.blink",
            async = true,
            enabled = function()
              local disabled_fts = { oil = true, snacks_picker_input = true }
              return not disabled_fts[vim.bo.filetype]
            end,
          },
        },
      },
    },
  },

  -- Colorizer
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = colorizer.opts,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        opts = {},
        config = function(_, opts)
          require("treesitter-context").setup(opts)
        end,
      },
    },
    config = function()
      require("nvim-treesitter").install(treesitter.ensure_installed)
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = mason.opts,
  },

  -- File Browser
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = oil.opts,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Startup Dashboard
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    opts = dashboard.opts,
    config = function(_, opts)
      opts.config.header = dashboard.generate_header()
      require("dashboard").setup(opts)
    end,
  },

  -- Debugger
  {
    "mfussenegger/nvim-dap",
    ft = { "js", "ts" },
    config = function()
      require "configs.dap"
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    after = "nvim-dap",
    dependencies = { "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },

  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "haydenmeade/neotest-jest",
      "antoinemadec/FixCursorHold.nvim",
    },
    ft = { "js", "ts" },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-jest" {
            jestCommand = "npm test -- --watch ",
          },
        },
      }
    end,
  },

  -- Git Diffs
  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
  },

  -- GitHub Integration
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      picker = "snacks",
    },
  },

  -- Auto-tagging
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "jsx", "markdown", "tsx", "typescript", "xml", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Highlight Comments
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- Remote Development
  {
    name = "remote-sshfs.nvim",
    dir = "~/projects/remote-sshfs.nvim",
    lazy = false,
    opts = remotesshfs.opts,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Motion/Flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end },
    },
  },

  -- Rust Tooling
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
  },

  -- SchemaStore Support
  { "b0o/schemastore.nvim" },

  -- Multiplexer Integration
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Force good Vim habits
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
    lazy = false,
  },

  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cmd = { "ObsidianToday", "ObsidianNew" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = obsidian.opts,
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
  },

  -- TypeScript Tools
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },

  -- Grafana Alloy
  {
    "https://github.com/grafana/vim-alloy",
    lazy = false,
  },

  -- Snacks (picker, scroll, ui_select)
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 10, total = 75 },
        },
      },
      picker = {
        ui_select = true,
        layout = {
          preset = "default",
        },
        matcher = {
          fuzzy = true,
          smartcase = true,
          ignorecase = true,
          frecency = true,
        },
        win = {
          input = {
            keys = {
              ["<C-q>"] = { "close", mode = { "i", "n" } },
              ["<C-f>"] = { "qflist", mode = { "i", "n" } },
              ["<Tab>"] = { "list_down", mode = { "i", "n" } },
              ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
              ["<C-s>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<C-i>"] = { "edit_split", mode = { "i", "n" } },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fw", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
      { "<leader>fo", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fa", function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find all files" },
      { "<leader>fz", function() Snacks.picker.lines() end, desc = "Find in current buffer" },
      { "<leader>ma", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>cm", function() Snacks.picker.git_log() end, desc = "Git commits" },
      { "<leader>gt", function() Snacks.picker.git_status() end, desc = "Git status" },
    },
  },

  -- Wakatime
  {
    "wakatime/vim-wakatime",
    enabled = false,
  },

  -- Codeium
  {
    "Exafunction/windsurf.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("codeium").setup {
        enable_chat = false,
        enable_cmp_source = false,
        filetypes = {
          oil = false,
          snacks_picker_input = false,
        },
      }
    end,
  },

  -- Vim Be Better
  {
    "szymonwilczek/vim-be-better",
    cmd = "VimBeBetter",
  },

  -- Find and Replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    config = function()
      require("grug-far").setup {}
    end,
  },
}
