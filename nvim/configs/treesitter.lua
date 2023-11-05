local M = {}

M.opts = {
	ensure_installed = {
		"vim",
		"lua",
		"html",
		"css",
		"scss",
		"dockerfile",
		"go",
		"gomod",
		"json",
		"jsdoc",
		"make",
		"prisma",
		"python",
		"regex",
		"php",
		"sql",
		"terraform",
		"toml",
		"yaml",
		"java",
		"kotlin",
		"javascript",
		"typescript",
		"tsx",
		"rust",
		"just",
		"hcl",
		"markdown",
		"markdown_inline",
	},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
		disable = {
			"python",
		},
	},
}

return M
