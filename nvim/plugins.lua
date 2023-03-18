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
	-- Install plugins
	{
		-- Rust
		"simrat39/rust-tools.nvim",
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
}

return plugins
