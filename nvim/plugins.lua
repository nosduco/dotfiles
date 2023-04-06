local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

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
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},
	{
		"hrsh7th/nvim-cmp",
		opts = overrides.cmp,
	},
	{
		-- Disable built-in terminal
		"NvChad/nvterm",
		enabled = false,
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
	{
		dir = "~/Projects/remote-sshfs.nvim",
		-- "nosduco/remote-sshfs.nvim",
		lazy = false,
		opts = {
			connections = {
				custom_hosts = {},
			},
			handlers = {
				on_connect = {
					change_dir = false,
					find_files = false,
				},
				on_disconnect = {
					clean_mount_folders = true,
				},
			},
			ui = {
				confirm = {
					connect = false,
					change_dir = false,
				},
			},
			log = {
				enabled = true,
				types = {
					all = true,
				},
			},
		},
		config = function(_, opts)
			require("remote-sshfs").setup(opts)
		end,
	},
	{
		-- Rust
		"simrat39/rust-tools.nvim",
	},
	{
		-- Just
		"IndianBoy42/tree-sitter-just",
		lazy = false,
		opts = {},
		config = function(_, opts)
			require("tree-sitter-just").setup(opts)
		end,
	},
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		opts = {},
		config = function(_, opts)
			require("smart-splits").setup(opts)
		end,
	},
	-- {
	-- 	-- Tmux integration
	-- 	"numToStr/Navigator.nvim",
	-- 	lazy = false,
	-- 	opts = {},
	-- 	config = function(_, opts)
	-- 		require("Navigator").setup(opts)
	-- 	end,
	-- },
	{
		-- Terminal Plugin
		"akinsho/toggleterm.nvim",
		-- TODO: Figure out how to lazy load this on map
		lazy = false,
		version = "*",
		opts = overrides.toggleterm,
		config = function(_, opts)
			require("toggleterm").setup(opts)
		end,
	},
	{
		-- Markdown functionality
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
