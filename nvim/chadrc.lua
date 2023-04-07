---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	-- Set theme
	theme = "nos",

	-- Override highlights
	hl_override = highlights.override,
	hl_add = highlights.add,

	-- Cheatsheet
	cheatsheet = {
		theme = "simple",
	},

	-- Statusline
	statusline = {
		theme = "default",
		separator_style = "arrow",
	},

	-- Tabufline
	tabufline = {
		overriden_modules = function()
			return {
				-- Disable top right toggle theme/close all buttons
				buttons = function()
					return ""
				end,
			}
		end,
	},
}

M.plugins = "custom.plugins"

M.mappings = require("custom.mappings")

return M
