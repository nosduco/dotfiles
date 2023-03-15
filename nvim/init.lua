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
  callback = open_nvim_tree
})

-- Neovide (Neovim GUI) options
if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.75
end
