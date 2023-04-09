local M = {}

M.opts = {
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
}

return M
