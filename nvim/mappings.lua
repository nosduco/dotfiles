---@type MappingsTable
local M = {}

M.disabled = {
	-- Disable default key-binds
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

		-- Vertical and Horizontal Splits
		["<C-s>"] = { "<cmd> split <CR>", "horizontal split" },
		["<C-i>"] = { "<cmd> vsplit <CR>", "vertical split" },

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

		["<leader>df"] = { "<cmd> DiffviewOpen <CR>", "view git diffs interactively" },
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
		["<leader>xx"] = { "<cmd>TroubleToggle<cr>", "toggle lsp diagnostic list" },
		["<leader>xw"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "toggle lsp workspace diagnostic list" },
		["<leader>xf"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "toggle lsp file diagnostic list" },
		["<leader>xl"] = { "<cmd>TroubleToggle loclist<cr>", "toggle lsp loclist" },
		["<leader>xq"] = { "<cmd>TroubleToggle quickfix<cr>", "toggle lsp quickfix list" },
	},
}

M.telescope = {
	n = {
		["<leader>rc"] = { "<cmd> Telescope remote-sshfs connect <CR>" },
	},
}

return M
