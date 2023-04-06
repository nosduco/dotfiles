local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {
	-- Spelling
	-- b.diagnostics.cspell,
	-- b.code_actions.cspell,

	-- Web
	b.formatting.eslint_d,
	b.diagnostics.eslint_d,
	-- b.formatting.prettier,

	-- Go
	b.diagnostics.golangci_lint,
	b.formatting.gofmt,
	b.formatting.goimports_reviser,

	-- Rust
	b.formatting.rustfmt,

	-- Terraform
	b.formatting.terraform_fmt,

	-- Lua
	b.formatting.stylua,

	-- Github Actions
	b.diagnostics.actionlint,

  -- PHP
  b.diagnostics.php,

	-- Python
	-- b.formatting.autopep8,
  b.formatting.black,
  -- b.diagnostics.pylint,
  b.diagnostics.flake8,

	-- Markup/Markdown
	-- b.diagnostics.yamllint,
	-- b.formatting.yamlfmt,
	-- b.formatting.markdownlint,

	-- Justfile
	b.formatting.just,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
