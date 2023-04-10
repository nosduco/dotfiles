local M = {}

M.opts = {
	shortcut_type = "number",
	config = {
		shortcut = {
			{
				desc = "󰇚 Update",
				group = "@annotation",
				action = "NvChadUpdate",
				key = "u",
			},
			{
				desc = "󰱼 Find Files",
				group = "@function",
				action = "Telescope find_files",
				key = "f",
			},
			{
				desc = " Projects",
				group = "@string",
				action = function()
					require("telescope").extensions.file_browser.file_browser({
						path = vim.fn.expand("$HOME") .. "/Projects",
						hide_parent_dir = true,
					})
				end,
				key = "p",
			},
			{
				desc = " dotfiles",
				group = "Number",
				action = function()
					local dotfiles_dir = vim.fn.expand("$HOME") .. "/Projects/dotfiles"
					vim.fn.execute("cd " .. dotfiles_dir)
					-- Configure tmux to open new panes inside this window to the new cwd
					os.execute(
						"tmux set-hook -w after-split-window 'send-keys \"cd " .. dotfiles_dir .. " && clear\" Enter'"
					)
					vim.cmd(":NvimTreeToggle")
				end,
				key = "d",
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
	table.insert(header, os.date("%Y-%m-%d %l:%M:%S %p"))
	table.insert(header, "")
	return header
end

return M
