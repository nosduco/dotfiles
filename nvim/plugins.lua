local dashboard = require("custom.configs.dashboard")
local remotesshfs = require("custom.configs.remote-sshfs")
local cmp = require("custom.configs.cmp")
local treesitter = require("custom.configs.treesitter")
local mason = require("custom.configs.mason")
local telescope = require("custom.configs.telescope")
local dressing = require("custom.configs.dressing")
local yank = require("custom.configs.yank")
local neorg = require("custom.configs.neorg")
local colorizer = require("custom.configs.colorizer")

---@type NvPluginSpec[]
local plugins = {
	-- Disable Plugins
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
					require("custom.configs.lint")
				end,
			},
			-- Formatting
			{
				"stevearc/conform.nvim",
				config = function()
					require("custom.configs.conform")
				end,
			},
			{
				"mfussenegger/nvim-jdtls",
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = colorizer.opts,
	},
	-- Override plugin configs
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
			{
				-- Justfile (tree-sitter support)
				"IndianBoy42/tree-sitter-just",
				ft = "just",
				config = function(_, opts)
					require("tree-sitter-just").setup(opts)

					local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
					parser_config.hypr = {
						install_info = {
							url = "https://github.com/luckasRanarison/tree-sitter-hypr",
							files = { "src/parser.c" },
							branch = "master",
						},
						filetype = "hypr",
					}
				end,
			},
		},
		opts = treesitter.opts,
		lazy = false,
	},
  -- File Browser
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      keymaps = {
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-i>"] = "actions.select_split",
        ["q"] = ":q<CR>",
        ["s"] = function()
          require('leap').leap { opts = { labels = {} } }
        end
      },
      view_options = {
        show_hidden = true
      },
      float = {
        padding = 9,
      },
      delete_to_trash = true,
    },
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
	{
		"williamboman/mason.nvim",
		opts = mason.opts,
	},
	{
		"hrsh7th/nvim-cmp",
		opts = cmp.opts,
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
		-- Enhanced Yank and Put
		"gbprod/yanky.nvim",
		event = "VimEnter",
		opts = yank.opts,
		config = function(_, opts)
			require("yanky").setup(opts)
		end,
	},
	{
		-- Debugger
		"mfussenegger/nvim-dap",
		ft = { "js", "ts" },
		config = function()
			require("custom.configs.dap")
		end,
	},
	{
		-- Debugger UI
		"rcarriga/nvim-dap-ui",
		after = "nvim-dap",
		config = function()
			require("dapui").setup()
		end,
	},
	{
		-- Debugger in-line variables
		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
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
			require("neotest").setup({
				adapters = {
					require("neotest-jest")({
						jestCommand = "npm test -- --watch ",
					}),
				},
			})
		end,
	},
	{
		-- Git Diffs
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
	},
	{
		-- Git Integration
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		opts = {},
		config = function(_, opts)
			require("neogit").setup(opts)
		end,
	},
	{
		-- Code Diagnostics Lightbulb
		"kosayoda/nvim-lightbulb",
		event = "VeryLazy",
		config = function()
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
			})
		end,
	},
	{
		-- Diagnostic Pane
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		commands = { "TroubleToggle" },
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
	{
		"ggandor/flit.nvim",
		lazy = false,
		config = function()
			require("flit").setup()
		end,
	},
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
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = {
			"markdown",
		},
	},
	{
		-- Force good Vim movement/habits
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
		opts = {},
		lazy = false,
	},
	{
		--- Neorg
		"nvim-neorg/neorg",
		ft = "norg",
		cmd = "Neorg",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = neorg.opts,
		build = function()
			vim.cmd(":Neorg sync-parsers")
		end,
		config = function(_, opts)
			require("neorg").setup(opts)
		end,
	},
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "folke/drop.nvim",
    event = "VimEnter",
    config = function()
      require("drop").setup({
        theme = "snow"
      })
    end,
  }
}

return plugins
