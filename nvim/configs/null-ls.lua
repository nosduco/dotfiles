local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {
	-- Spelling
	b.diagnostics.codespell,
	b.formatting.codespell.with({ args = { "--check-hidden", "$FILENAME" } }),

	-- Web
	b.formatting.eslint_d,
	b.diagnostics.eslint_d,
	-- b.formatting.prettierd,

	-- Docker
	b.diagnostics.hadolint,

	-- Go
	b.diagnostics.golangci_lint,
	b.formatting.gofmt,
	b.formatting.goimports_reviser,

	-- Rust
	b.formatting.rustfmt,

	-- Terraform
	b.formatting.terraform_fmt,
	b.diagnostics.terraform_validate,
	b.diagnostics.tfsec,

	-- Lua
	b.formatting.stylua,

	-- Github Actions
	b.diagnostics.actionlint,

	-- PHP
	b.diagnostics.php,

	-- Python
	b.formatting.ruff,
	b.diagnostics.ruff,

	-- Dotenv
	b.diagnostics.dotenv_linter,
	b.hover.printenv,

	-- SQL
	b.diagnostics.sqlfluff.with({
		extra_args = { "--dialect", "postgres" }, -- change to your dialect
	}),

	-- Yaml
	b.diagnostics.yamllint.with({
		args = { "-d", "{extends: default, rules: {document-start: disable, truthy: { allowed-values: ['true', 'false', 'on' ]}, line-length: disable }}", "--format", "parsable", "-" },
	}),

	-- Markup/Markdown
	b.formatting.markdownlint,
	b.diagnostics.markdownlint,

	-- Justfile
	b.formatting.just,

	-- Zsh
	b.diagnostics.zsh,
}

null_ls.setup({
	debug = true,
	sources = sources,
  temp_dir = "/tmp"
})
