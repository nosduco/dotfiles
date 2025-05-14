local M = {}

M.opts = {
  strategies = {
    chat = {
      adapter = "anthropic",
      tools = {
        groups = {
          ["agent"] = {
            description = "Agent - Can run code, edit code and modify files",
            system_prompt = "**DO NOT** make any assumptions about the dependencies that a user has installed. If you need to install any dependencies to fulfil the user's request, do so via the Command Runner tool. If the user doesn't specify a path, use their current working directory.",
            tools = {
              "cmd_runner",
              "editor",
              "files",
            },
          },
        },
      },
    },
    inline = {
      adapter = "anthropic",
    },
    cmd = {
      adapter = "anthropic",
    },
  },
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        model = {
          default = "claude-3-7-sonnet-20250219",
        },
        env = {
          api_key = "cmd:echo $ANTHROPIC_API_KEY",
        },
      })
    end,
  },
  display = {
    diff = {
      provider = "mini_diff",
    },
  },
}

return M
