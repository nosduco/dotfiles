local o = vim.opt
local g = vim.g
local autocmd = vim.api.nvim_create_autocmd

-- Core options (previously from NvChad)
o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"
o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true
o.fillchars = { eob = " " }
o.mouse = "a"
o.number = true
o.numberwidth = 2
o.ruler = false
o.shortmess:append "sI"
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
o.updatetime = 250
o.whichwrap:append "<>[]hl"

-- Disable unused providers
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Add mason binaries to PATH
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin:" .. vim.env.PATH

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


-- Add HTTP filetype
vim.filetype.add {
  extension = {
    ["http"] = "http",
  },
}

-- Keep cursor centered
vim.opt.scrolloff = 999

-- Snacks Picker highlights
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksPickerMatch", { fg = "#fab387", bold = true })
    vim.api.nvim_set_hl(0, "SnacksPickerPrompt", { fg = "#fab387" })
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#7f849c" })
    vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#cdd6f4" })
  end,
})
vim.cmd "doautocmd ColorScheme"

-- Search Options
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
