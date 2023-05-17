local M = {}

-- Custom keybinds for nvim-tree
local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
end

M.opts = {
  on_attach = on_attach,
	git = {
		enable = true,
		ignore = false,
	},
	renderer = {
		highlight_git = true,
    root_folder_label = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
	view = {
		adaptive_size = true,
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
