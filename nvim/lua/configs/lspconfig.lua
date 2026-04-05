-- LSP on_attach keymaps
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "<leader>D", vim.lsp.buf.type_definition, "Go to type definition")
  map("n", "<leader>ra", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "gr", vim.lsp.buf.references, "Show references")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "List workspace folders")
end

-- LSP capabilities (for blink.cmp completion)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  },
}

-- Configure diagnostic display
vim.diagnostic.config {
  virtual_text = { prefix = "" },
  signs = true,
  underline = true,
  update_in_insert = false,
  float = { border = "single" },
}

-- Default server config
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Servers with default config
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

-- Lua LSP
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
      },
    },
  },
})
vim.lsp.enable("lua_ls")

-- TypeScript (uses typescript-tools plugin)
require("typescript-tools").setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Terraform
vim.lsp.config("terraformls", {
  filetypes = { "tf", "terraform", "terraform-vars" },
})
vim.lsp.enable("terraformls")

-- Rust (rustaceanvim handles LSP automatically, no setup needed here)

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
