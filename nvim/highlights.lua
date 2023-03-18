-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type HLTable
M.override = {
	St_NormalMode = { bg = "orange", bold = true },
	St_NormalModeSep = { fg = "orange" },
	St_cwd_sep = { fg = "yellow" },
	St_cwd_icon = { bg = "yellow" },
	St_LspStatus = { fg = "orange" },
	St_pos_sep = { fg = "orange" },
	St_pos_icon = { bg = "orange" },
	St_pos_text = { fg = "orange" },
}

---@type HLTable
M.add = {}

return M
