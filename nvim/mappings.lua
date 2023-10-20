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
		["j"] = "",
		["k"] = "",
		["<leader>x"] = "",
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
		["<C-s>"] = { "<cmd> vsplit <CR>", "vertical split" },

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
		["<leader>xd"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "toggle lsp file diagnostic list" },
		["<leader>xl"] = { "<cmd>TroubleToggle loclist<cr>", "toggle lsp loclist" },
		["<leader>xq"] = { "<cmd>TroubleToggle quickfix<cr>", "toggle lsp quickfix list" },
		-- Autoformat via lsp
		["<leader>fm"] = {
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

M.tabs = {
	n = {
		["<leader>tn"] = { "<cmd>tabnew <CR>", "open new tab" },
		["<leader>t1"] = { "1gt", "go to tab #1" },
		["<leader>t2"] = { "2gt", "go to tab #2" },
		["<leader>t3"] = { "3gt", "go to tab #3" },
		["<leader>t4"] = { "4gt", "go to tab #4" },
		["<leader>t5"] = { "5gt", "go to tab #5" },
		["<leader>t6"] = { "6gt", "go to tab #6" },
	},
}

M.yank = {
	n = {
		["<leader>pp"] = { "<cmd>Telescope yank_history <CR>" },
		["<leader>pb"] = { "<Plug>(YankyCycleBackward)" },
		["<leader>pn"] = { "<Plug>(YankyCycleForward)" },
	},
}

M.debugger = {
	n = {
		["<leader>db"] = {
			function()
				require("dapui").toggle()
			end,
			"toggle debugger ui",
		},
		["<leader>dbp"] = {
			function()
				require("dap").toggle_breakpoint()
			end,
			"toggle breakpoint",
		},
		["<leader>dbc"] = {
			function()
				require("dap").continue()
			end,
			"continue debugger",
		},
		["<leader>dbs"] = {
			function()
				require("dap").step_into()
			end,
			"step into debugger",
		},
		["<leader>dbr"] = {
			function()
				require("dap").repl.open()
			end,
			"open repl debugger",
		},
	},
}

M.testing = {
	n = {
		["<leader>tr"] = {
			function()
				require("neotest").run.run()
			end,
			"run tests",
		},
		["<leader>ts"] = {
			function()
				require("neotest").run.stop()
			end,
			"stop tests",
		},
		["<leader>td"] = {
			function()
				require("neotest").run.stop({ strategy = "dap" })
			end,
			"debug tests",
		},
		["<leader>tt"] = {
			function()
				-- require("neotest").output_panel.toggle()
				require("neotest").summary.toggle()
			end,
			"toggle testing pane",
		},
		["<leader>tc"] = {
			function()
				require("neotest").output.toggle()
			end,
			"toggle testing pane",
		},
	},
}

return M
