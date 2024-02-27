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
		-- Disable default Nvim-Tree keybind
		["<C-n>"] = "",
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

		-- Move down and up (centered)
		["<C-d>"] = { "<C-d>zz" },
		["<C-u>"] = { "<C-u>zz" },

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

		["gf"] = {
			function()
				if require("obsidian").util.cursor_on_markdown_link() then
					return "<cmd>ObsidianFollowLink<CR>"
				else
					return "gf"
				end
			end,
		},
	},
	t = {
		-- Exit
		["<Esc>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },

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
		["<C-/>"] = {
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
		["<C-/>"] = {
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
	},
}

M.telescope = {
	n = {
		["<leader>rc"] = { "<cmd> Telescope remote-sshfs connect <CR>" },
	},
}

M.tabs = {
	n = {
		-- Old Tab keybind setup
		-- ["<leader>tn"] = { "<cmd>tabnew <CR>", "open new tab" },
		-- ["<leader>t1"] = { "1gt", "go to tab #1" },
		-- ["<leader>t2"] = { "2gt", "go to tab #2" },
		-- ["<leader>t3"] = { "3gt", "go to tab #3" },
		-- ["<leader>t4"] = { "4gt", "go to tab #4" },
		-- ["<leader>t5"] = { "5gt", "go to tab #5" },
		-- ["<leader>t6"] = { "6gt", "go to tab #6" },
		["<C-a>1"] = { "1gt", "go to tab #1" },
		["<C-a>2"] = { "2gt", "go to tab #2" },
		["<C-a>3"] = { "3gt", "go to tab #3" },
		["<C-a>4"] = { "4gt", "go to tab #4" },
		["<C-a>5"] = { "5gt", "go to tab #5" },
		["<C-a>6"] = { "6gt", "go to tab #6" },
	},
	t = {},
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

M.directories = {
	n = {
		["<C-n>"] = { "<cmd> Oil --float <CR>", "Toggle file browser" },
	},
}

M.git = {
	n = {
		["<leader>gt"] = {
			function()
				require("neogit").open()
			end,
			"toggle git view",
		},
	},
}

M.mux = {
	n = {
		["<C-a>i"] = { "<cmd> vsplit | terminal<CR>", "vertical split terminal" },
		["<C-a>s"] = { "<cmd> split | terminal <CR>", "horizontal split terminal" },
		["<C-a>c"] = { "<cmd> tabnew | terminal <CR>", "create new tab and terminal" },
	},
	t = {
		["<C-a>c"] = { "<cmd> tabnew | terminal <CR>", "create new tab and terminal" },
		["<C-a>1"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "1gt", "go to tab #1" },
		["<C-a>2"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "2gt", "go to tab #2" },
		["<C-a>3"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "3gt", "go to tab #3" },
		["<C-a>4"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "4gt", "go to tab #4" },
		["<C-a>5"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "5gt", "go to tab #5" },
		["<C-a>6"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "6gt", "go to tab #6" },
		["<C-a>i"] = {
			vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "<cmd> vsplit | terminal<CR>",
			"vertical split terminal",
		},
		["<C-a>s"] = {
			vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "<cmd> split | terminal <CR>",
			"horizontal split terminal",
		},
		["<C-a>c"] = {
			vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "<cmd> tabnew | terminal <CR>",
			"create new tab and terminal",
		},
	},
}

return M
