local dashboard = require("custom.configs.dashboard")
local remotesshfs = require("custom.configs.remote-sshfs")
local nvimtree = require("custom.configs.nvim-tree")
local cmp = require("custom.configs.cmp")
local treesitter = require("custom.configs.treesitter")
local mason = require("custom.configs.mason")
local toggleterm = require("custom.configs.toggleterm")
local telescope = require("custom.configs.telescope")
local octo = require("custom.configs.octo")
local dressing = require("custom.configs.dressing")

---@type NvPluginSpec[]
local plugins = {
	-- Disable Plugins
	{
		"NvChad/nvterm",
		enabled = false,
	},
	-- Override plugin definition options
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Format & Linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},
	-- Override plugin configs
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{
				-- Justfile (tree-sitter support)
				"IndianBoy42/tree-sitter-just",
				ft = "just",
				config = function(_, opts)
					require("tree-sitter-just").setup(opts)
				end,
			},
		},
		opts = treesitter.opts,
		lazy = false,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = nvimtree.opts,
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
    'stevearc/dressing.nvim',
    event = "VeryLazy",
    opts = dressing.opts,
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
          })
        }
      })
		end,
	},
	{
		-- Git Diffs
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
	},
	{
		-- Github Integration
		"pwntester/octo.nvim",
		cmd = "Octo",
		opts = octo.opts,
		config = function(_, opts)
			require("octo").setup(opts)
		end,
	},
	{
		-- Diagnostic Pane
		"folke/trouble.nvim",
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
		-- Pane Terminal
		"akinsho/toggleterm.nvim",
		keys = "<C-t>",
		version = "*",
		opts = toggleterm.opts,
	},
	{
		-- Markdown (preview, other configurations)
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = {
			"markdown",
		},
	},
}

return plugins
