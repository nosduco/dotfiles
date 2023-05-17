local M = {}

-- Create tmux hook to set adjacent panes to cwd
M.set_tmux_cwd = function(cwd)
	os.execute("tmux set-hook -w after-split-window 'send-keys \"cd " .. cwd .. " && clear\" Enter'")
end

-- Set current directory of Vim and create tmux hook to set adjacent panes to cwd
M.set_cwd = function(cwd)
	vim.fn.execute("cd " .. cwd)
	M.set_tmux_cwd(cwd)
end

-- Clean-up all tmux hooks created during session
M.clear_tmux_hooks = function()
	os.execute("tmux set-hook -wu after-split-window")
end

return M
