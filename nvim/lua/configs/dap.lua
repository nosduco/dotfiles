local dap = require "dap"

-- Node Debugger Adapter
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/bin/js-debug-adapter",
    args = { "${port}" },
  },
}

-- Javascript Debugging
dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
}

-- Typescript Debugging
dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Debug tests",
    trace = true, -- include debugger info
    runtimeExecutable = "node",
    runtimeArgs = {
      "./node_modules/jest/bin/jest.js",
      "--runInBand",
    },
    rootPath = "${workspaceFolder}",
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Debug Nest Framework",
    args = { "${workspaceFolder}/src/main.ts" },
    runtimeArgs = { "--nolazy", "-r", "ts-node/register", "-r", "tsconfig-paths/register" },
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
  },
}

-- NestJS (Typescript) Debugging
