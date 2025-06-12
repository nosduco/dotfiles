local M = {}

M.opts = {
  connections = {
    sshfs_args = {
      "-o reconnect",
      "-o ConnectTimeout=5",
      "-o follow_symlinks",
    },
  },
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
      connect = true,
      change_dir = false,
    },
  },
  log = {
    enabled = false,
    -- enabled = true,
    types = {
      all = true,
    },
  },
}

return M
