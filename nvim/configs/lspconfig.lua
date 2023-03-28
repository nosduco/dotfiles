local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

local servers = {
	"html",
	"cssls",
	"tsserver",
	"clangd",
	"docker_compose_language_service",
	"dockerls",
	"terraformls",
	-- "pyright",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Rust
local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
})

-- Yaml
lspconfig.yamlls.setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
			},
		},
	},
})

-- Python
lspconfig.pyright.setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
  settings = {
    python = {
      typeCheckingMode = "basic",
      diskCachePath = "/tmp/"
    }
  }
})
-- lspconfig.pylsp.setup({
-- 	server = {
-- 		on_attach = on_attach,
-- 		capabilities = capabilities,
-- 	},
-- 	settings = {
-- 		pylsp = {
-- 			plugins = {
-- 				pycodestyle = {
-- 					ignore = { "W391" },
-- 					maxLineLength = 100,
-- 				},
-- 			},
-- 		},
-- 	},
-- })
