require "nvchad.options"

local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Neovim Terminal settings
autocmd("TermOpen", {
  pattern = "*",
  command = "setlocal nonumber norelativenumber",
})

autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert",
})

autocmd("BufWinEnter", {
  pattern = "term://*",
  command = "startinsert",
})

autocmd("WinEnter", {
  pattern = "term://*",
  command = "startinsert",
})

autocmd("TermClose", {
  pattern = "*",
  callback = function(event)
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(event.buf, { force = true })
    end
  end,
})

-- Clear TMUX hooks on exit
vim.cmd [[ autocmd VimLeave * lua require("custom.utils").clear_tmux_hooks()]]

-- Set statusline to 0
vim.o.cmdheight = 0

-- Enable relative line numbers
vim.cmd "set rnu!"

-- Neovide (Neovim GUI) options
if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.75
  vim.o.guifont = "JetBrainsMono Nerd Font:10"
  vim.g.neovide_fullscreen = false
  vim.g.neovide_remember_window_size = false
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_floating_blur_amount_x = 1.0
  vim.g.neovide_floating_blur_amount_y = 1.0
  vim.g.neovide_confirm_quit = true

  vim.keymap.set("v", "<C-S-c>", '"+y') -- Copy
  vim.keymap.set("n", "<C-S-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<C-S-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<C-S-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<C-S-v>", '<ESC>l"+Pli') -- Paste insert mode

  vim.o.cmdheight = 1
end
-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<C-S-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })

-- Set underscores as keyword for horizontal movement
vim.cmd "set iskeyword-=_"

-- Fix Terraform filetyping
vim.cmd [[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]]
vim.cmd [[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]]
vim.cmd [[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]]
vim.cmd [[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]]
vim.cmd [[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]]

-- Fix hyprland config
vim.cmd [[autocmd BufRead,BufNewFile hyprland.conf,hyprpaper.conf set filetype=hypr]]

-- Conceal setting for Obsidian
vim.opt.conceallevel = 1

vim.opt.signcolumn = "yes"
