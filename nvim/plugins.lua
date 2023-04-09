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
		lazy = false,
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
	-- Startup Dashboard
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		opts = {
			shortcut_type = "number",
			config = {
				shortcut = {
					{
						desc = "󰇚 Update",
						group = "@annotation",
						action = "NvChadUpdate",
						key = "u",
					},
					{
						desc = "󰱼 Find Files",
						group = "@function",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = " Projects",
						group = "@string",
						action = function()
							local dotfiles_dir = vim.fn.expand("$HOME") .. "/Projects"
							vim.fn.execute("cd " .. dotfiles_dir)
							vim.cmd(":NvimTreeToggle")
						end,
						key = "p",
					},
					{
						desc = " dotfiles",
						group = "Number",
						action = function()
							local dotfiles_dir = vim.fn.expand("$HOME") .. "/Projects/dotfiles"
							vim.fn.execute("cd " .. dotfiles_dir)
							vim.cmd(":NvimTreeToggle")
							-- vim.cmd("Telescope find_files")
						end,
						key = "d",
					},
				},
				packages = { enable = false },
				footer = {},
			},
		},
		config = function(_, opts)
			local header = {
				"",
				" ██╗  ██╗███████╗██╗     ██╗      ██████╗        ████████╗ ██████╗ ███╗   ██╗██╗   ██╗ ",
				" ██║  ██║██╔════╝██║     ██║     ██╔═══██╗       ╚══██╔══╝██╔═══██╗████╗  ██║╚██╗ ██╔╝ ",
				" ███████║█████╗  ██║     ██║     ██║   ██║          ██║   ██║   ██║██╔██╗ ██║ ╚████╔╝  ",
				" ██╔══██║██╔══╝  ██║     ██║     ██║   ██║          ██║   ██║   ██║██║╚██╗██║  ╚██╔╝   ",
				" ██║  ██║███████╗███████╗███████╗╚██████╔╝▄█╗       ██║   ╚██████╔╝██║ ╚████║   ██║    ",
				" ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝       ╚═╝    ╚═════╝ ╚═╝  ╚═══╝   ╚═╝    ",
				"",
			}
			table.insert(header, os.date("%Y-%m-%d %l:%M:%S %p"))
			table.insert(header, "")
			opts.config.header = header
			require("dashboard").setup(opts)
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
	},
	{
		"folke/trouble.nvim",
		opts = {},
		config = function(_, opts)
			require("trouble").setup(opts)
		end,
	},
	{
		"folke/todo-comments.nvim",
		opts = {},
		event = "VeryLazy",
		config = function(_, opts)
			require("todo-comments").setup(opts)
		end,
	},
	{
		-- My remote-sshfs plugin :)
		dir = "~/Projects/remote-sshfs.nvim",
		lazy = false,
		opts = {
			handlers = {
				on_connect = {
					change_dir = true,
				},
				on_disconnect = {
					clean_mount_folders = true,
				},
			},
			log = {
				enabled = false,
				types = {
					all = true,
				},
			},
		},
		config = function(_, opts)
			require("remote-sshfs").setup(opts)
		end,
	},
	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("nvim-surround").setup(opts)
		end,
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
		opts = {},
		config = function(_, opts)
			require("tree-sitter-just").setup(opts)
		end,
	},
	-- Multiplexer Integration
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		opts = {},
		config = function(_, opts)
			require("smart-splits").setup(opts)
		end,
	},
	{
		-- Pane Terminal
		"akinsho/toggleterm.nvim",
		keys = "<C-t>",
		version = "*",
		opts = overrides.toggleterm,
		config = function(_, opts)
			require("toggleterm").setup(opts)
		end,
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
