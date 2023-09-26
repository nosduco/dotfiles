local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
	pattern = "*",
	command = "tabdo wincmd =",
})

-- Open nvim-tree on directories (and update cwd)
local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	-- do not open if buffer is file
	if not directory then
		return
	end

	-- change to the directory
	vim.cmd.cd(data.file)

	-- open the tree
	require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Clear TMUX hooks on exit
vim.cmd([[ autocmd VimLeave * lua require("custom.utils").clear_tmux_hooks()]])

-- Set statusline to 0
vim.o.cmdheight = 0

-- Enable relative line numbers
vim.cmd("set rnu!")

-- Neovide (Neovim GUI) options
if vim.g.neovide then
	vim.g.neovide_scale_factor = 0.75
end

vim.cmd("set iskeyword-=_")

-- Fix Terraform filetyping
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
