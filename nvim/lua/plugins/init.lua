local dashboard = require "configs.dashboard"
local remotesshfs = require "configs.remote-sshfs"
local treesitter = require "configs.treesitter"
local mason = require "configs.mason"
-- telescope and dressing removed - using snacks picker + ui_select
local colorizer = require "configs.colorizer"
local oil = require "configs.oil"
local obsidian = require "configs.obsidian"
-- local avante = require "configs.avante"
-- local codecompanion = require "configs.codecompanion"

return {
  -- Disabled default plugins
  {
    "NvChad/nvterm",
    enabled = false,
  },
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  -- Override plugin definition options
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Linting
      {
        "mfussenegger/nvim-lint",
        config = function()
          require "configs.lint"
        end,
      },
      -- Formatting
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
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
   {
    "hrsh7th/nvim-cmp",
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdLineEnter" },

    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
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
        'Exafunction/codeium.nvim',
      },
    },

    opts_extend = { "sources.default" },

    opts = function()
      local nvchad_opts = require "nvchad.blink.config"
      return vim.tbl_deep_extend("force", nvchad_opts, {
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
      })
    end
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = colorizer.opts,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        -- Tree Sitter Context
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        opts = {},
        config = function(_, opts)
          require("treesitter-context").setup(opts)
        end,
      },
    },
    opts = treesitter.opts,
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    opts = mason.opts,
  },
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },
  -- Install plugins
  {
    -- File Browser
    "stevearc/oil.nvim",
    lazy = false,
    opts = oil.opts,
    -- config = function(opts)
    --   require("oil").setup(opts)
    -- end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    -- Startup Dashboard
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    opts = dashboard.opts,
    config = function(_, opts)
      opts.config.header = dashboard.generate_header()
      require("dashboard").setup(opts)
    end,
  },
  {
    -- Debugger
    "mfussenegger/nvim-dap",
    ft = { "js", "ts" },
    config = function()
      require "configs.dap"
    end,
  },
  {
    -- Debugger UI
    "rcarriga/nvim-dap-ui",
    after = "nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    -- Debugger in-line variables
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    -- Testing Functionality
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
  {
    -- Git Diffs
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
  },
  {
    -- GitHub Integration
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
  {
    -- Auto-tagging
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "jsx", "markdown", "tsx", "typescript", "xml", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    -- Highlight Comments
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    -- My remote-sshfs plugin :)
    name = "remote-sshfs.nvim",
    dir = "~/projects/remote-sshfs.nvim",
    -- "nosduco/remote-sshfs.nvim",
    lazy = false,
    opts = remotesshfs.opts,
  },
  {
    -- Surround
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    -- Motion/Flash
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end },
    },
  },
  -- {
  --   "ggandor/flit.nvim",
  --   lazy = false,
  --   config = function()
  --     require("flit").setup()
  --   end,
  -- },
  {
    -- Rust Tooling (replaces deprecated rust-tools.nvim)
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
  },
  {
    -- SchemaStore Support (json, yaml)
    "b0o/schemastore.nvim",
  },
  {
    -- Multiplexer Integration
    "mrjones2014/smart-splits.nvim",
    lazy = false,
  },
  {
    -- Markdown (preview, other configurations)
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    -- Force good Vim movement/habits
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
    lazy = false,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cmd = { "ObsidianToday", "ObsidianNew" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = obsidian.opts,
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
  {
    "https://github.com/grafana/vim-alloy",
    lazy = false,
  },
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
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
  {
    "Exafunction/windsurf.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup {
        enable_chat = false,
        enable_cmp_source = false,  -- disable cmp integration, use blink instead
        filetypes = {
          oil = false,
          snacks_picker_input = false,
        },
      }
    end,
  },
  {
    "szymonwilczek/vim-be-better",
    cmd = "VimBeBetter",
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    config = function()
      require("grug-far").setup {}
    end,
  },
}
