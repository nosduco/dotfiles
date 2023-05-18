local M = {}

M.opts = {
	-- Install certain packages outside package manager
	ensure_installed = {
		-- Docker
		"docker-compose-language-service",

		-- Github actions
		"actionlint",

		-- Debuggers
		"js-debug-adapter",
	},
}

return M
