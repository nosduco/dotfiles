local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

-- Open nvim-tree on start
local function open_nvim_tree()
	require("nvim-tree.api").tree.open()
end

autocmd("VimEnter", {
	callback = open_nvim_tree,
})

-- Custom command for cheatsheet
--autocmd("Cheatsheet", {
--	command = ":NvCheatsheet",
--})
--
local new_cmd = vim.api.nvim_create_user_command
new_cmd("Cheatsheet", function()
	vim.g.nvcheatsheet_displayed = not vim.g.nvcheatsheet_displayed

	if vim.g.nvcheatsheet_displayed then
		require("nvchad_ui.cheatsheet.simple")()
	else
		vim.cmd("bd")
	end
end, {})

-- Neovide (Neovim GUI) options
if vim.g.neovide then
	vim.g.neovide_scale_factor = 0.75
end
