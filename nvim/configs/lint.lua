local present, lint = pcall(require, "lint")

if not present then
	return
end

local node = { "eslint_d" }

lint.linters_by_ft = {
	yaml = { "actionlint", "yamllint" },
	typescript = node,
	javascript = node,
	javascriptreact = node,
	typescriptreact = node,
	docker = { "hadolint" },
	-- TODO: Does this work?
	terraform = { "tfsec" },
	tf = { "tfsec" },
	python = { "ruff" },
	-- TODO: Does this work?
	sh = { "dotenv_linter" },
	sql = { "sqlfluff" },
	markdown = { "markdownlint" },
	lua = { "luacheck" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
		lint.try_lint("codespell")
	end,
})