local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")

-- List of servers to load with default configurations
local servers = {
	"lua_ls",
	"html",
	"cssls",
	"tsserver",
	"graphql",
	-- "jdtls",
	-- "eslint",
	"docker_compose_language_service",
	"dockerls",
}

local home = vim.env.HOME
WORKSPACE_PATH = home .. "/workspace/"
lspconfig.jdtls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. "/home/tony/tools/jdtls/lombok.jar",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		"/home/tony/tools/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
		"-configuration",
		"/home/tony/tools/jdtls/config_linux",
		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		WORKSPACE_PATH,
	},
})

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
	filetypes = { "tf", "terraform" },
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
			validate = { enable = true },
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

local java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })
local jdtls = require("jdtls")

local function jdtls_setup(event)
	local home = os.getenv("HOME")
	local root_markers = { "gradlew", "mvnw", ".git" }

	local root_dir = require("jdtls.setup").find_root(root_markers)
	local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

	local config = {
		cmd = {
			"java",
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-javaagent:" .. "/home/tony/tools/jdtls/lombok.jar",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",
			"-jar",
			"/home/tony/tools/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
			"-configuration",
			"/home/tony/tools/jdtls/config_linux",
			-- 💀
			-- See `data directory configuration` section in the README
			"-data",
			workspace_folder,
		},
		root_dir = jdtls.setup.find_root({
			".git",
			"mvnw",
			"gradlew",
			"pom.xml",
			"build.gradle",
			"build.gradle.kts",
		}),
		settings = {
			signatureHelp = { enabled = true },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			},
			contentProvider = {
				preferred = "fernflower",
			},
			extendedClientCapabilities = jdtls.extendedClientCapabilities,
			-- Specify any options for organizing imports
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			java = {
				eclipse = {
					downloadSources = true,
				},
				maven = {
					downloadSources = true,
				},
				implementationCodeLens = {
					enabled = true,
				},
				referencesCodeLens = {
					enabled = true,
				},
				format = {
					enabled = true,
				},
				references = {
					includeDecompiledSources = true,
				},
				inlayHints = {
					parameterNames = {
						enabled = "all",
					},
				},
				configuration = {
					runtimes = {
						{
							name = "JavaSE-17",
							path = "/usr/lib/jvm/java-17-openjdk",
						},
					},
				},
			},
		},
		flags = {
			allow_incremental_sync = true,
		},
		on_attach = on_attach,
		capabilities = capabilities,
	}
	jdtls.start_or_attach(config)
end
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = java_cmds,
-- 	pattern = { "java" },
-- 	desc = "Setup jdtls",
-- 	callback = jdtls_setup,
-- })
--
-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   pattern = { "*.java" },
--   callback = function()
--     local _, _ = pcall(vim.lsp.codelens.refresh)
--   end,
-- })
