local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

-- List of servers to load with default configurations
local servers = {
	"html",
	"cssls",
	"tsserver",
	"docker_compose_language_service",
	"dockerls",
	-- "terraformls",
}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Terraform/HCL
lspconfig.terraformls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "tf", "terraform", "hcl" }
})

-- Rust
local rt = require("rust-tools")
rt.setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
})

-- JSON
lspconfig.jsonls.setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

-- YAML
lspconfig.yamlls.setup({
	server = {
		on_attach = on_attach,
		capabilities = capabilities,
	},
	settings = {
		yaml = {
			schemas = require("schemastore").yaml.schemas(),
      validate = { enable = true }
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
			enable = true,
			diskCachePath = "/tmp/",
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
			},
		},
	},
})
