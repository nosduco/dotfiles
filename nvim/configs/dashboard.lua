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
					local dotfiles_dir = vim.fn.expand("$HOME") .. "/Projects"
					vim.fn.execute("cd " .. dotfiles_dir)
					vim.cmd(":NvimTreeToggle")
				end,
				key = "p",
			},
			{
				desc = " dotfiles",
				group = "Number",
				action = function()
					local dotfiles_dir = vim.fn.expand("$HOME") .. "/Projects/dotfiles"
					vim.fn.execute("cd " .. dotfiles_dir)
					vim.cmd(":NvimTreeToggle")
					-- vim.cmd("Telescope find_files")
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
