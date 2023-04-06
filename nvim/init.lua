local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

-- Neovide (Neovim GUI) options
if vim.g.neovide then
	vim.g.neovide_scale_factor = 0.75
end

vim.diagnostic.config({
  virtual_text = {
    only_current_line = true
  },
})
