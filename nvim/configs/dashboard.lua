local utils = require("custom.utils")

local M = {}

M.opts = {
	shortcut_type = "number",
	config = {
		shortcut = {
			{
				desc = "󰱼 Find Files",
				group = "@function",
				action = "Telescope find_files",
				key = "f",
			},
			{
				desc = " Notes",
				group = "@type",
				action = function()
					local timestamp = os.time()
					local filename = tostring(os.date("%B-%d-%I%M%p", timestamp)):lower() .. ".txt"
					local path = vim.fn.expand("$HOME") .. "/notes/" .. filename
					vim.api.nvim_command("edit " .. path)
					local notes_dir = vim.fn.expand("$HOME") .. "/notes/"
					utils.set_cwd(notes_dir)
				end,
				key = "n",
			},
			{
				desc = " Projects",
				group = "@string",
				action = function()
					require("telescope").extensions.file_browser.file_browser({
						path = vim.fn.expand("$HOME") .. "/projects",
						hide_parent_dir = true,
					})
				end,
				key = "p",
			},
			{
				desc = " Work",
				group = "@file",
				action = function()
					require("telescope").extensions.file_browser.file_browser({
						path = vim.fn.expand("$HOME") .. "/work",
						hide_parent_dir = true,
					})
				end,
				key = "w",
			},
			{
				desc = " dotfiles",
				group = "Number",
				action = function()
					local dotfiles_dir = vim.fn.expand("$HOME") .. "/.dotfiles"
          utils.set_cwd(dotfiles_dir)
					vim.cmd(":NvimTreeToggle")
				end,
				key = "d",
			},
			{
				desc = "󰇚 Update",
				group = "@annotation",
				action = "NvChadUpdate",
				key = "u",
			},
		},
		packages = { enable = false },
		footer = {},
	},
}

M.generate_header = function()
	local header = {
		"",
		" ██╗  ██╗███████╗██╗     ██╗      ██████╗        ████████╗ ██████╗ ███╗   ██╗██╗   ██╗ ",
		" ██║  ██║██╔════╝██║     ██║     ██╔═══██╗       ╚══██╔══╝██╔═══██╗████╗  ██║╚██╗ ██╔╝ ",
		" ███████║█████╗  ██║     ██║     ██║   ██║          ██║   ██║   ██║██╔██╗ ██║ ╚████╔╝  ",
		" ██╔══██║██╔══╝  ██║     ██║     ██║   ██║          ██║   ██║   ██║██║╚██╗██║  ╚██╔╝   ",
		" ██║  ██║███████╗███████╗███████╗╚██████╔╝▄█╗       ██║   ╚██████╔╝██║ ╚████║   ██║    ",
		" ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝ ╚═╝       ╚═╝    ╚═════╝ ╚═╝  ╚═══╝   ╚═╝    ",
		"",
	}
  table.insert(header, os.date("%A, %B %e, %Y"))
	table.insert(header, "")
	return header
end

return M
