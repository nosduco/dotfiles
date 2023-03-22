-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type HLTable
M.override = {
	St_NormalMode = { bg = "orange", bold = true },
	St_NormalModeSep = { fg = "orange" },
	St_InsertMode = { bg = "yellow", bold = true },
	St_InsertModeSep = { fg = "yellow" },
	St_VisualMode = { bg = "red", bold = true },
	St_VisualModeSep = { fg = "red" },
	St_TerminalMode = { bg = "orange", bold = true },
	St_TerminalModeSep = { fg = "orange" },
	St_CommandMode = { bg = "orange", bold = true },
	St_CommandModeSep = { fg = "orange" },
	St_cwd_sep = { fg = "one_bg2" },
	St_cwd_icon = { bg = "one_bg2", fg = "orange" },
	St_cwd_text = { fg = "orange" },
	St_LspStatus = { fg = "green" },
	St_pos_sep = { fg = "orange" },
	St_pos_icon = { bg = "orange" },
	St_pos_text = { fg = "black2", bg = "orange" },
}

---@type HLTable
M.add = {}

return M
