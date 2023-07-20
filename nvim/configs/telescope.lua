local M = {}

M.opts = {
	extensions_list = {
		"file_browser",
		"themes",
		"terms",
		"remote-sshfs",
		"yank_history",
	},
	extensions = {
		file_browser = {
			mappings = {
				["i"] = {
					["<A-c>"] = false,
					["<S-CR>"] = false,
					["<A-r>"] = false,
					["<A-m>"] = false,
					["<A-y>"] = false,
					["<A-d>"] = false,
					["<C-o>"] = false,
					["<C-g>"] = false,
					["<C-e>"] = false,
					["<C-w>"] = false,
					["<C-t>"] = false,
					["<C-f>"] = false,
					["<C-h>"] = false,
					["<C-s>"] = false,
					["<bs>"] = false,
					["<CR>"] = function(prompt_bufnr)
						local action_state = require("telescope.actions.state")
						local entry_path = action_state.get_selected_entry().Path
						local path = entry_path:is_dir() and entry_path:absolute() or entry_path:parent():absolute()
						vim.fn.execute("cd " .. path)
						-- Configure tmux to open new panes inside this window to the new cwd
						os.execute(
							"tmux set-hook -w after-split-window 'send-keys \"cd " .. path .. " && clear\" Enter'"
						)
						require("telescope.actions").close(prompt_bufnr)
						vim.cmd(":NvimTreeToggle")
					end,
					["<C-j>"] = require("telescope.actions").move_selection_next,
					["<C-k>"] = require("telescope.actions").move_selection_previous,
					["<ESC>"] = require("telescope.actions").close,
				},
				["n"] = {
					["q"] = require("telescope.actions").close,
					["c"] = false,
					["r"] = false,
					["m"] = false,
					["y"] = false,
					["d"] = false,
					["o"] = false,
					["g"] = false,
					["e"] = false,
					["w"] = false,
					["t"] = false,
					["f"] = false,
					["h"] = false,
					["s"] = false,
				},
			},
		},
	},
}

return M
