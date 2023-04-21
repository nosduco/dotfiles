local M = {}

M.set_tmux_cwd = function(cwd)
	os.execute("tmux set-hook -w after-split-window 'send-keys \"cd " .. cwd .. " && clear\" Enter'")
end

M.set_cwd = function(cwd)
	vim.fn.execute("cd " .. cwd)
	M.set_tmux_cwd(cwd)
end

M.clear_tmux_hooks = function()
	os.execute("tmux set-hook -wu after-split-window")
end

return M
