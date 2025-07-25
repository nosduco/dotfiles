local dashboard = require "configs.dashboard"
local remotesshfs = require "configs.remote-sshfs"
local treesitter = require "configs.treesitter"
local mason = require "configs.mason"
local telescope = require "configs.telescope"
local dressing = require "configs.dressing"
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
    end, -- Override to setup mason-lspconfig
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = colorizer.opts,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = false,
        config = function()
          require("ts_context_commentstring").setup {
            enable_autocmd = false,
          }
        end,
      },
    },
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
    opts = telescope.opts,
    dependencies = {
      {
        "nvim-telescope/telescope-file-browser.nvim",
      },
    },
  },
  -- Install plugins
  {
    -- File Browser
    "stevearc/oil.nvim",
    lazy = false,
    opts = oil.opts,
    config = function(opts)
      require("oil").setup(opts)
      require("remote-sshfs.filebrowser.oil").setup_signs { hl = "DiagnosticHint" }
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", "remote-sshfs.nvim" },
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
    -- Select/Input Dialog
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = dressing.opts,
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
    -- Diagnostic Pane
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "TroubleToggle" },
    opts = {},
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
    -- Motion/Leap
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      require("leap").add_default_mappings()
      require("leap").opts.highlight_unlabeled_phase_one_targets = true
    end,
  },
  -- {
  --   "ggandor/flit.nvim",
  --   lazy = false,
  --   config = function()
  --     require("flit").setup()
  --   end,
  -- },
  {
    -- Rust Tooling
    "simrat39/rust-tools.nvim",
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
    "karb94/neoscroll.nvim",
    lazy = false,
    config = function()
      require("neoscroll").setup {}
    end,
  },
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    opts = {},
  },
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },
  {
    "coder/claudecode.nvim",
    config = true,
    keys = {
      -- { "<leader>a", nil, desc = "AI/Claude Code" },
      -- { "<leader>aa", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      -- { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      -- { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>ai", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      -- {
      --   "<leader>as",
      --   "<cmd>ClaudeCodeTreeAdd<cr>",
      --   desc = "Add file",
      --   ft = { "NvimTree", "neo-tree" },
      -- },
    },
  },
  {
    "Exafunction/windsurf.nvim",
    -- lazy = "VeryLazy",
    lazy = false,
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup {
        virtual_text = {
          enabled = true,
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
