-- Servers with default config (capabilities/on_init inherited from NvChad's "*" config)
local servers = {
  "html",
  "cssls",
  "graphql",
  "docker_compose_language_service",
  "dockerls",
  "tailwindcss",
  "helm_ls",
  "eslint",
}

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

-- ESLint: add auto-fix on save
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "eslint" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        command = "EslintFixAll",
      })
    end
  end,
})

-- TypeScript (uses typescript-tools plugin)
require("typescript-tools").setup {
  on_attach = require("nvchad.configs.lspconfig").on_attach,
  on_init = require("nvchad.configs.lspconfig").on_init,
  capabilities = require("nvchad.configs.lspconfig").capabilities,
}

-- Terraform
vim.lsp.config("terraformls", {
  filetypes = { "tf", "terraform", "terraform-vars" },
})
vim.lsp.enable("terraformls")

-- Rust (uses rust-tools plugin)
require("rust-tools").setup {
  server = {
    on_attach = require("nvchad.configs.lspconfig").on_attach,
    on_init = require("nvchad.configs.lspconfig").on_init,
    capabilities = require("nvchad.configs.lspconfig").capabilities,
  },
}

-- JSON
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})
vim.lsp.enable("jsonls")

-- YAML
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
      ignore = {
        "**/charts/**/templates/*.yaml",
      },
    },
  },
})
vim.lsp.enable("yamlls")

-- Python
vim.lsp.config("pyright", {
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
vim.lsp.enable("pyright")

-- Java
local home = vim.env.HOME
local WORKSPACE_PATH = home .. "/workspace/"
vim.lsp.config("jdtls", {
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
    "-data",
    WORKSPACE_PATH,
  },
})
vim.lsp.enable("jdtls")
