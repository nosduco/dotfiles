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
	-- Install plugins
	{
		dir = "~/Projects/remote-sshfs.nvim",
		lazy = false,
		opts = {
			connections = {
				custom_hosts = {},
			},
			handlers = {
				on_connect = {
					find_files = true,
				},
				on_disconnect = {
					clean_mount_folders = true,
				},
			},
      ui = {
        confirm = {
          connect = true,
          change_dir = true,
        }
      },
			log = {
				enabled = false,
				types = {
					all = true,
					config = true,
					sshfs = true,
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
		-- Tmux integration
		"numToStr/Navigator.nvim",
		lazy = false,
		opts = {},
		config = function(_, opts)
			require("Navigator").setup(opts)
		end,
	},
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
