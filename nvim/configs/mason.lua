local M = {}

M.opts = {
	ensure_installed = {
		-- Lua
		"lua-language-server",
		"stylua",

		-- Docker
		"docker-compose-language-service",
		"dockerfile-language-server",

		-- Web
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"eslint_d",
		"prettier",
		"prisma-language-server",

		-- Rust
		"rust-analyzer",
		"rustfmt",

		-- Python
		"pyright",

		-- Terraform
		"terraform-ls",

		-- Github actions
		"actionlint",

		-- Yaml
		"yaml-language-server",

		-- Misc
		"cspell",
	},
}

return M
