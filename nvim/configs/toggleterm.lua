local M = {}

M.opts = {
	open_mapping = [[<c-t>]],
	insert_mappings = true,
	terminal_mappings = true,
	direction = "vertical",
	close_on_exit = true,
	size = vim.o.columns * 0.25,
}

return M
