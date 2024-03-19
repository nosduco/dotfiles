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
  ui = {
    confirm = {
      connect = false,
      change_dir = false,
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
