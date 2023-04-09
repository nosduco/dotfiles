local M = {}

M.opts = {
	git = {
		enable = true,
		ignore = false,
	},
	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "s", action = "vsplit" },
				{ key = "i", action = "split" },
				{ key = "u", action = "dir_up" },
			},
		},
	},
	actions = {
		open_file = {
			quit_on_open = true,
			window_picker = {
				enable = false,
			},
		},
	},
}

return M
