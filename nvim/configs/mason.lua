local M = {}

M.opts = {
  -- Install certain packages outside package manager
	ensure_installed = {
		-- Docker
		"docker-compose-language-service",

		-- Github actions
		"actionlint",
	},
}

return M
