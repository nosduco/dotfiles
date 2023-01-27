local builtin = require('telescope.builtin')
vim.keymap.set('', '<C-space>', builtin.find_files, {})
-- TODO: Add shift-control-space for grep 
-- vim.keymap.set('', '<C-space>', builtin.live_grep, {})
