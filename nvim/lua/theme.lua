-- Set vim backgrond
vim.o.background = "dark"

-- Custom colors
local bg = "#121212"
local accent = "#E95420"
local special = "#FF8F40"
local line = "#1C1C1C"
local panel_bg = "#1C1C1C"
local panel_shadow = "#1C1C1C"
local selection_inactive = "#303030"

-- Initalize ayu colorscheme with custom colors
require('ayu').setup({
  mirage = false,
  overrides = {
    Normal = { bg = bg },
    NormalFloat = { bg = bg },
    ColorColumn = { bg = line },
    CursorColumn = { bg = line },
    CursorLineNr = { fg = accent, bg = line },
    CursorLine = { bg = line },
    CursorLineConceal = { bg = line },
    CursorWord = { bg = selection_inactive },
    CursorWord0 = { bg = selection_inactive },
    CursorWord1 = { bg = selection_inactive },
    PmenuSel = { bg = selection_inactive },
    IncSearch = { bg = selection_inactive },
    SpecialKey = { fg = selection_inactive },
    Visual = { bg = selection_inactive },
    DiffChange = { bg = selection_inactive },
    VertSplit = { bg = bg },
    FoldColumn = { bg = bg },
    Folded = { bg = panel_bg },
    SignColumn = { bg = bg },
    Search = { fg = bg, bg = special },
    CurSearch = { fg = bg , bg = accent },
    StatusLine = { bg = panel_bg },
    StatusLineNC = { bg = panel_bg },
    TabLine = { bg = panel_shadow },
    TabLineSel = { bg = bg },
    WhichKeyFloat = { bg = bg },
    PreProc = { fg = accent },
    Structure = { fg = special },
    Delimiter = { fg = special },
    Special = { fg = accent },
    markdownCode = { fg = special },
    LeapLabelPrimary = { fg = bg },
    LeapLabelSecondary = { fg = bg },
    LeapLabelSelected = { fg = bg },
    VM_Mono = { fg = bg },
    VM_Extend = { bg = selection_inactive },
    VM_Cursor = { bg = selection_inactive },
    TelescopePromptBorder = { fg = accent },
    NeogitDiffContextHighlight = { bg = line },
    NeogitHunkHeaderHighlight = { bg = line },
    NvimTreeGitDirty = { fg = accent },
    NvimTreeFolderIcon = { fg = accent },
    NvimTreeFolderName = { fg = special },
    NvimTreeOpenedFolderName = { fg = special },
    CmdItemKindColor = { fg = special },
    CmdItemKindFile = { fg = special },
    CmpItemKindReference = { fg = special },
    CmpItemKindFolder = { fg = special },
    DapUIStoppedThread = { fg = special },
  },
})

-- Configure vim with ayu
require('ayu').colorscheme()
