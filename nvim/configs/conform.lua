local present, conform = pcall(require, "conform")

if not present then
	return
end

local node = { "eslint_d" }

conform.setup({
	formatters_by_ft = {
		typescript = node,
		javascript = node,
		javascriptreact = node,
		typescriptreact = node,
		rust = { "rustfmt" },
		java = { "astyle" },
		terraform = { "terraform_fmt" },
		lua = { "stylua" },
		-- python = { "ruff" },
		markdown = { "markdownlint" },
	},
	format_after_save = {
		lsp_fallback = true,
	},
	notify_on_error = true,
})
