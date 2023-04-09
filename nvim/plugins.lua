local dashboard = require("custom.configs.dashboard")
local remotesshfs = require("custom.configs.remote-sshfs")
local nvimtree = require("custom.configs.nvim-tree")
local cmp = require("custom.configs.cmp")
local treesitter = require("custom.configs.treesitter")
local mason = require("custom.configs.mason")
local toggleterm = require("custom.configs.toggleterm")

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
		opts = {
			extensions_list = {
				"themes",
				"terms",
				"remote-sshfs",
			},
		},
	},
	-- {
	-- 	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	-- 	opts = {},
	-- 	lazy = false,
	-- 	config = function(_, opts)
	-- 		require("lsp_lines").setup(opts)
	-- 	end,
	-- },
	-- Install plugins
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
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
	},
	{
		"folke/trouble.nvim",
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
	},
	{
		-- My remote-sshfs plugin :)
		dir = "~/Projects/remote-sshfs.nvim",
		lazy = false,
		opts = remotesshfs.opts,
	},
	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
	},
	-- Motion/Leap
	{
		"ggandor/leap.nvim",
		lazy = false,
		config = function()
			require("leap").add_default_mappings()
			require("leap").opts.highlight_unlabeled_phase_one_targets = true
		end,
	},
	{
		-- Rust
		"simrat39/rust-tools.nvim",
	},
	-- SchemaStore Support (json, yaml)
	{
		"b0o/schemastore.nvim",
	},
	{
		-- Just
		"IndianBoy42/tree-sitter-just",
		ft = "just",
	},
	-- Multiplexer Integration
	{
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
