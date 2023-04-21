local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

-- Clear TMUX hooks on exit
vim.cmd([[ autocmd VimLeave * lua require("custom.utils").clear_tmux_hooks()]])

-- Neovide (Neovim GUI) options
if vim.g.neovide then
	vim.g.neovide_scale_factor = 0.75
end
