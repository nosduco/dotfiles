---@type MappingsTable
local M = {}

M.disabled = {
	-- Disable default keybinds
	n = {
		["<leader>/"] = "",
    ["<leader> + wK"] = "",
    ["<leader> + wk"] = "",
    ["<A-i>"] = "",
    ["<A-v>"] = "",
    ["<A-h>"] = "",
    ["<leader> + h"] = "",
    ["<leader> + v"] = "",
	},
	i = {},
	v = {
		["<C-F>"] = "",
		["<leader>/"] = "",
	},
  t = {
    ["<A-i>"] = "",
    ["<A-v>"] = "",
    ["<A-h>"] = "",
  },
}

M.general = {
	n = {
		-- Shortcut to command
		[";"] = { ":", "enter command mode", opts = { nowait = true } },

		-- Tmux navigation
		["<C-h>"] = { "<CMD>NavigatorLeft<CR>", "navigate left" },
		["<C-l>"] = { "<CMD>NavigatorRight<CR>", "navigate right" },
		["<C-j>"] = { "<CMD>NavigatorUp<CR>", "navigate down" },
		["<C-k>"] = { "<CMD>NavigatorDown<CR>", "navigate up" },
	},
}

M.comment = {
	-- Toggle comment in both modes
	n = {
		["<C-_>"] = {
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			"toggle comment",
		},
	},

	v = {
		["<C-_>"] = {
			"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			"toggle comment",
		},
	},
}

M.lspconfig = {
	n = {
		-- Autoformat via lsp
		["<C-f>"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"lsp formatting",
		},
	},
	i = {
		-- Autoformat via lsp
		["<C-f>"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"lsp formatting",
		},
	},
	v = {
		-- Autoformat via lsp
		["<C-f>"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"lsp formatting",
		},
	},
}

M.telescope = {
  n = {
    ["<leader>rc"] = { "<cmd> Telescope remote-sshfs connect <CR>" }
  }
}

return M
