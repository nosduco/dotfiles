---@type MappingsTable
local M = {}

M.disabled = {
	-- Disable default keybinds
	n = {
		["<leader>/"] = "",
		["<leader> + wK"] = "",
		["<leader> + wk"] = "",
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

		-- Multiplexer Navigation
		["<C-h>"] = {
			function()
				require("smart-splits").move_cursor_left()
			end,
		},
		["<C-j>"] = {
			function()
				require("smart-splits").move_cursor_down()
			end,
		},
		["<C-k>"] = {
			function()
				require("smart-splits").move_cursor_up()
			end,
		},
		["<C-l>"] = {
			function()
				require("smart-splits").move_cursor_right()
			end,
		},

		-- Multiplexer/Pane Resizing
		["<A-h>"] = {
			function()
				require("smart-splits").resize_left()
			end,
		},
		["<A-j>"] = {
			function()
				require("smart-splits").resize_down()
			end,
		},
		["<A-k>"] = {
			function()
				require("smart-splits").resize_up()
			end,
		},
		["<A-l>"] = {
			function()
				require("smart-splits").resize_right()
			end,
		},
	},
	t = {
		-- Multiplexer Navigation
		["<C-h>"] = {
			function()
				require("smart-splits").move_cursor_left()
			end,
		},
		["<C-j>"] = {
			function()
				require("smart-splits").move_cursor_down()
			end,
		},
		["<C-k>"] = {
			function()
				require("smart-splits").move_cursor_up()
			end,
		},
		["<C-l>"] = {
			function()
				require("smart-splits").move_cursor_right()
			end,
		},

		-- Multiplexer/Pane Resizing
		["<A-h>"] = {
			function()
				require("smart-splits").resize_left()
			end,
		},
		["<A-j>"] = {
			function()
				require("smart-splits").resize_down()
			end,
		},
		["<A-k>"] = {
			function()
				require("smart-splits").resize_up()
			end,
		},
		["<A-l>"] = {
			function()
				require("smart-splits").resize_right()
			end,
		},
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
}

M.telescope = {
	n = {
		["<leader>rc"] = { "<cmd> Telescope remote-sshfs connect <CR>" },
	},
}

return M
