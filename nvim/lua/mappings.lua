require "nvchad.mappings"
local neoscroll = require "neoscroll"

local map = vim.keymap.set

-- Disable mappings
local nomap = vim.keymap.del
nomap("n", "<leader>/")
nomap("n", "<leader>x")
nomap("v", "<leader>/")
nomap("t", "<A-i>")
nomap("t", "<A-v>")
nomap("t", "<A-h>")
nomap("n", "<C-n>")

-- General
map("n", ";", ":", { desc = "Enter command mode" })
map("n", "<C-q>", "<cmd> confirm q <CR>", { desc = "Quit with confirmation" })

-- map("n", "<C-u>", "<C-u>zz", { desc = "Page up (center screen)" })
-- map("n", "<C-d>", "<C-d>zz", { desc = "Page down (center screen)" })
map("n", "<C-u>", function()
  neoscroll.ctrl_u { duration = 75 }
  vim.api.nvim_command "normal! zz"
end, { desc = "Page up (center screen)" })
map("n", "<C-d>", function()
  neoscroll.ctrl_d { duration = 75 }
  vim.api.nvim_command "normal! zz"
end, { desc = "Page down (center screen)" })
map("n", "<C-s>", "<cmd> vsplit <CR>", { desc = "Create vertical split" })
map({ "n", "t" }, "<C-h>", function()
  require("smart-splits").move_cursor_left()
end, { desc = "Move focus to left pane" })
map({ "n", "t" }, "<C-j>", function()
  require("smart-splits").move_cursor_down()
end, { desc = "Move focus to below pane" })
map({ "n", "t" }, "<C-k>", function()
  require("smart-splits").move_cursor_up()
end, { desc = "Move focus to above pane" })
map({ "n", "t" }, "<C-l>", function()
  require("smart-splits").move_cursor_right()
end, { desc = "Move focus to right pane" })
require("smart-splits").resize_left()
map({ "n", "t" }, "<A-h>", function() end, { desc = "Resize pane to the left" })
map({ "n", "t" }, "<A-j>", function()
  require("smart-splits").resize_down()
end, { desc = "Resize pane downward" })
map({ "n", "t" }, "<A-k>", function()
  require("smart-splits").resize_up()
end, { desc = "Resize pane upward" })
map({ "n", "t" }, "<A-l>", function()
  require("smart-splits").resize_right()
end, { desc = "Resize pane to the right" })
map("n", "<leader>df", "<cmd> DiffviewOpen <CR>", { desc = "View git diff interactively" })
map("n", "gf", function()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "gf"
  end
end, { desc = "Follow link under cursor" })
map("t", "<Esc>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape terminal mode" })

-- Line Manipulation
-- TODO: Get this to work
-- map("n", "y/", "yygccp", { remap = false, desc = "Copy and comment out line" })
-- map("v", "y/", "ygvgc`>p", { remap = false, desc = "Copy and comment out lines" })
-- map("n", "<C-", "yygccp", { remap = false, desc = "Copy and comment out line" })
-- map("v", "yc", "ygvgc`>p", { remap = false, desc = "Copy and comment out lines" })
map("v", "J", ":m '>+1<CR>gv=gv", { remap = true, desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { remap = true, desc = "Move selected lines down" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })

-- File System
map("n", "<C-n>", "<cmd> Oil <CR>", { desc = "Toggle file browser" })

-- Tabs
map("n", "<C-a>1", "1gt", { desc = "Go to tab #1" })
map("n", "<C-a>2", "2gt", { desc = "Go to tab #2" })
map("n", "<C-a>3", "3gt", { desc = "Go to tab #3" })
map("n", "<C-a>4", "4gt", { desc = "Go to tab #4" })
map("n", "<C-a>5", "5gt", { desc = "Go to tab #5" })
map("n", "<C-a>6", "6gt", { desc = "Go to tab #6" })
map("n", "<leader>tn", "<cmd> tabnew <CR>", { desc = "Open new tab" })
map("n", "<leader>t1", "1gt", { desc = "Go to tab #1" })
map("n", "<leader>t2", "2gt", { desc = "Go to tab #2" })
map("n", "<leader>t3", "3gt", { desc = "Go to tab #3" })
map("n", "<leader>t4", "4gt", { desc = "Go to tab #4" })
map("n", "<leader>t5", "5gt", { desc = "Go to tab #5" })
map("n", "<leader>t6", "6gt", { desc = "Go to tab #6" })

-- Yank (Copy/Paste)
map("n", "<leader>pp", "<cmd> Telescope yank_history <CR>", { desc = "Open yank history dialog" })
map("n", "<leader>pb", "<Plug>(YankyCycleBackward)", { desc = "Cycle current yank backward" })
map("n", "<leader>pn", "<Plug>(YankyCycleForeward)", { desc = "Cycle current yank forward" })

-- Multiplexer Navigation
map("n", "<C-a>i", "<cmd> vsplit | terminal <CR>", { desc = "Create terminal vertical split" })
map("n", "<C-a>s", "<cmd> split | terminal <CR>", { desc = "Create terminal horizontal split" })
map("n", "<C-a>c", "<cmd> tabnew | terminal <CR>", { desc = "Create new terminal tab" })
map("t", "<C-a>1", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "1gt", { desc = "Go to tab #1" })
map("t", "<C-a>2", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "2gt", { desc = "Go to tab #2" })
map("t", "<C-a>3", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "3gt", { desc = "Go to tab #3" })
map("t", "<C-a>4", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "4gt", { desc = "Go to tab #4" })
map("t", "<C-a>5", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "5gt", { desc = "Go to tab #5" })
map("t", "<C-a>6", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "6gt", { desc = "Go to tab #6" })
map(
  "t",
  "<C-a>i",
  vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "<cmd> vsplit | terminal<CR>",
  { desc = "Create terminal vertical split" }
)
map(
  "t",
  "<C-a>s",
  vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "<cmd> split | terminal<CR>",
  { desc = "Create terminal horizontal split" }
)
map(
  "t",
  "<C-a>c",
  vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true) .. "<cmd> split | terminal<CR>",
  { desc = "Create new terminal tab" }
)

-- Comments
map("n", "<C-_>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment under current line" })
map("n", "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment under current line" })
map(
  "v",
  "<C-_>",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Toggle comments for selected lines" }
)
map(
  "v",
  "<C-/>",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Toggle comments for selected lines" }
)

-- LSP
-- TODO: Do I still use trouble?
map("n", "<leader>xx", "<cmd> TroubleToggle <CR>", { desc = "Toggle LSP diagnostic list" })
map(
  "n",
  "<leader>xw",
  "<cmd> TroubleToggle workspace_diagnostics <CR>",
  { desc = "Toggle LSP workspace diagnostic list" }
)
map("n", "<leader>xd", "<cmd> TroubleToggle document_diagnostics <CR>", { desc = "Toggle LSP file diagnostic list" })
map("n", "<leader>xl", "<cmd> TroubleToggle loclist<CR>", { desc = "Toggle LSP loclist" })
map("n", "<leader>xq", "<cmd> TroubleToggle quickfix <CR>", { desc = "Toggle LSP quickfix list" })
map("n", "<leader>lf", vim.diagnostic.open_float, { noremap = true, silent = true })

-- Debugging
map("n", "<leader>db", function()
  require("dapui").toggle()
end, { desc = "Toggle debugging UI" })
map("n", "<leader>dbp", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle debugging breakpoint" })
map("n", "<leader>dbc", function()
  require("dap").continue()
end, { desc = "Debugger continue" })
map("n", "<leader>dbs", function()
  require("dap").step_into()
end, { desc = "Debugger step into" })
map("n", "<leader>dbr", function()
  require("dap").repl.open()
end, { desc = "Open debugger REPL" })

-- Testing
map("n", "<leader>tr", function()
  require("neotest").run.run()
end, { desc = "Run test under cursor" })
map("n", "<leader>ts", function()
  require("neotest").run.stop()
end, { desc = "Stop test under cursor" })
map("n", "<leader>td", function()
  require("neotest").run.stop { strategy = "dap" }
end, { desc = "Toggle test debugger UI" })
map("n", "<leader>tt", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle tests pane" })
map("n", "<leader>tc", function()
  require("neotest").output.toggle()
end, { desc = "Toggle test output pane" })

-- Remote Development
map("n", "<leader>rc", "<cmd> Telescope remote-sshfs connect <CR>", { desc = "Open remote SSHFS connection dialog" })

-- Find and Replace
map("n", "<leader>fr", "<cmd> GrugFar <CR>", { desc = "Find and replace" })
