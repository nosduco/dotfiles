-- Tabs Configuration
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Line Configuration
vim.opt.number = true
vim.opt.display = "lastline"
vim.opt.signcolumn = 'yes'

-- Highlight Configuration
vim.opt.showmatch = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.cmd([[
  highlight Directory ctermfg=5
  hi Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight ExtraWhitespace guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
]])

-- Status Bar Configuration
vim.opt.laststatus = 2
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.hidden = true
-- TODO: Figure out what to do here
-- let g:bufferline_echo=0

-- Syntax Configuration
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- TMUX Patch
vim.opt.ttimeoutlen = 0

-- Temp Directory/Swap Configuration
vim.opt.directory = "/tmp/"
vim.opt.shortmess = "ac"
-- vim.opt.nobackup = true
-- vim.opt.nowritebackup = true
vim.opt.updatetime = 300

-- Files Configuration
vim.opt.autoread = true

-- Split Configuration
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Mouse Support
vim.opt.mouse = "a"

-- Filetype Configuration
-- HTML Templating Languages
vim.cmd([[
  au BufNewFile,BufRead *.ejs set filetype=html
  au BufNewFile,BufRead *.njk set filetype=html
]])

-- Terminal Setup
-- TODO: Check if outside of tmux, if so run the commands below
-- vim.cmd([[
  -- let $NVIM_TUI_ENABLE_TRUE_COLOR=1
-- ]])
vim.opt.termguicolors = true
vim.cmd("set t_Co=256")

-- Movement Keybinds (Ctrl+h,j,k,l pane movement)
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', {})
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k', {})
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>h', {})
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>l', {})

-- Tab Keybinds
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-t>', '<Esc>:tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-]>', '<Cmd>BufferNext<CR>', { noremap = true, silent = true })

