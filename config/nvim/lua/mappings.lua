local map = vim.keymap.set

-- Insert mode navigation (from NvChad)
map("i", "<C-b>", "<ESC>^i", { desc = "Move to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move to end of line" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

-- General
map("n", ";", ":", { desc = "Enter command mode" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })
map("n", "<C-q>", "<cmd> confirm q <CR>", { desc = "Quit with confirmation" })
map("n", "<C-s>", "<cmd> vsplit <CR>", { desc = "Create vertical split" })

-- Scrolling
map("n", "<C-u>", "<C-u>zz", { desc = "Page up (center screen)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Page down (center screen)" })

-- Toggle options
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle line numbers" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "Toggle relative numbers" })

-- Format
map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format file" })

-- Diagnostics
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
map("n", "<leader>lf", vim.diagnostic.open_float, { noremap = true, silent = true })

-- Window navigation (smart-splits)
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
map({ "n", "t" }, "<A-h>", function()
  require("smart-splits").resize_left()
end, { desc = "Resize pane to the left" })
map({ "n", "t" }, "<A-j>", function()
  require("smart-splits").resize_down()
end, { desc = "Resize pane downward" })
map({ "n", "t" }, "<A-k>", function()
  require("smart-splits").resize_up()
end, { desc = "Resize pane upward" })
map({ "n", "t" }, "<A-l>", function()
  require("smart-splits").resize_right()
end, { desc = "Resize pane to the right" })

-- Git
map("n", "<leader>df", "<cmd> DiffviewOpen <CR>", { desc = "View git diff interactively" })

-- Obsidian
map("n", "gf", function()
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "gf"
  end
end, { desc = "Follow link under cursor" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Exit terminal mode" })
map("t", "<Esc>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), { desc = "Escape terminal mode" })

-- Line Manipulation
map("v", "J", ":m '>+1<CR>gv=gv", { remap = true, desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { remap = true, desc = "Move selected lines up" })

-- File System
map("n", "<C-n>", "<cmd> Oil <CR>", { desc = "Toggle file browser" })

-- Buffers
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

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
map("n", "<leader>pp", "<cmd> YankyRingHistory <CR>", { desc = "Open yank history dialog" })
map("n", "<leader>pb", "<Plug>(YankyCycleBackward)", { desc = "Cycle current yank backward" })
map("n", "<leader>pn", "<Plug>(YankyCycleForeward)", { desc = "Cycle current yank forward" })

-- Multiplexer Navigation (Terminal splits)
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

-- Comments (native gcc/gc, remapped to C-/)
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment under current line" })
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment under current line" })
map("v", "<C-_>", "gc", { remap = true, desc = "Toggle comments for selected lines" })
map("v", "<C-/>", "gc", { remap = true, desc = "Toggle comments for selected lines" })

-- Allow clipboard copy paste in neovim
map("", "<C-S-v>", "+p<CR>", { noremap = true, silent = true })
map("!", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })
map("t", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })
map("v", "<C-S-v>", "<C-R>+", { noremap = true, silent = true })

-- WhichKey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Show all keymaps" })
map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "Query keymaps" })

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
map("n", "<leader>rc", "<cmd> RemoteSSHFSConnect <CR>", { desc = "Open remote SSHFS connection dialog" })

-- Find and Replace
map("n", "<leader>fr", "<cmd> GrugFar <CR>", { desc = "Find and replace" })

-- GitHub (Octo)
map("n", "<leader>gp", "<cmd> Octo pr list <CR>", { desc = "List pull requests" })
map("n", "<leader>gi", "<cmd> Octo issue list <CR>", { desc = "List issues" })
map("n", "<leader>gn", "<cmd> Octo notification list <CR>", { desc = "List notifications" })
map("n", "<leader>ga", function()
  if vim.bo.filetype == "octo" then
    vim.cmd "Octo pr checks"
  else
    vim.cmd "Octo run list"
  end
end, { desc = "View actions/CI checks" })
map("n", "<leader>gc", "<cmd> Octo pr create <CR>", { desc = "Create pull request" })
map("n", "<leader>gr", "<cmd> Octo review start <CR>", { desc = "Start/resume PR review" })

-- Claude Code
map("n", "<leader>cc", "<cmd>ClaudeCodeContinue<CR>", { desc = "Toggle Claude Code" })
