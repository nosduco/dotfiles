require "nvchad.options"

vim.g.maplocalleader = ","

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
vim.cmd [[ autocmd VimLeave * lua require("utils").clear_tmux_hooks()]]

-- Set statusline to 0
vim.o.cmdheight = 0

-- Enable relative line numbers
vim.cmd "set rnu!"

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

-- Settings for avante nvim
vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"

-- Add HTTP filetype
vim.filetype.add {
  extension = {
    ["http"] = "http",
  },
}

-- Search Options
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
