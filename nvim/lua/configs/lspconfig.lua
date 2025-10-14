local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- List of servers to load with default configurations
local servers = {
  "html",
  "cssls",
  "graphql",
  "docker_compose_language_service",
  "dockerls",
  "tailwindcss",
  "helm_ls",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- Javascript/Typescript
lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  on_init = on_init,
  capabilities = capabilities,
}

local ts = require "typescript-tools"
ts.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

-- Lua
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          "vim",
        },
      },
    },
  },
}

-- Terraform/HCL
lspconfig.terraformls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "tf", "terraform", "terraform-vars" },
}

-- Rust
local rt = require "rust-tools"
rt.setup {
  server = {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  },
}

-- JSON
lspconfig.jsonls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

-- YAML
lspconfig.yamlls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
      ignore = {
        "**/charts/**/templates/*.yaml", -- or wherever your helm templates live
      },
    },
  },
}

-- Python
lspconfig.pyright.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
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
}

-- Java
local home = vim.env.HOME
local WORKSPACE_PATH = home .. "/workspace/"
lspconfig.jdtls.setup {
  on_attach = on_attach,
  on_init = on_init,
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
}
