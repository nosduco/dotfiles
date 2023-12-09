local M = {}

M.opts = {
	load = {
		["core.keybinds"] = {
			config = {
				default_keybinds = true,
				neorg_leader = "<space>",
			},
		},
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
        name = "[Neorg]"
      }
    },
		["core.defaults"] = {}, -- Loads default behaviour
		["core.concealer"] = {}, -- Adds pretty icons to your documents
		["core.dirman"] = { -- Manages Neorg workspaces
			config = {
				workspaces = {
					notes = "~/notes/home",
					work = "~/notes/work",
				},
			},
		},
	},
}

return M
