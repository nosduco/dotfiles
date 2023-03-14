-- Set vim backgrond
-- vim.o.background = "dark"

-- Custom colors
-- local bg = "#121212"
-- local accent = "#E95420"
-- local special = "#FF8F40"
-- local line = "#1C1C1C"
-- local panel_bg = "#1C1C1C"
-- local panel_shadow = "#1C1C1C"
-- local selection_inactive = "#303030"

-- Initalize ayu colorscheme with custom colors
-- require('ayu').setup({
--   mirage = false,
--   overrides = {
--     Normal = { bg = bg },
--     NormalFloat = { bg = bg },
--     ColorColumn = { bg = line },
--     CursorColumn = { bg = line },
--     CursorLineNr = { fg = accent, bg = line },
--     CursorLine = { bg = line },
--     CursorLineConceal = { bg = line },
--     CursorWord = { bg = selection_inactive },
--     CursorWord0 = { bg = selection_inactive },
--     CursorWord1 = { bg = selection_inactive },
--     PmenuSel = { bg = selection_inactive },
--     IncSearch = { bg = selection_inactive },
--     SpecialKey = { fg = selection_inactive },
--     Visual = { bg = selection_inactive },
--     DiffChange = { bg = selection_inactive },
--     VertSplit = { bg = bg },
--     FoldColumn = { bg = bg },
--     Folded = { bg = panel_bg },
--     SignColumn = { bg = bg },
--     Search = { fg = bg, bg = special },
--     CurSearch = { fg = bg , bg = accent },
--     StatusLine = { bg = panel_bg },
--     StatusLineNC = { bg = panel_bg },
--     TabLine = { bg = panel_shadow },
--     TabLineSel = { bg = bg },
--     WhichKeyFloat = { bg = bg },
--     PreProc = { fg = accent },
--     Structure = { fg = special },
--     Delimiter = { fg = special },
--     Special = { fg = accent },
--     markdownCode = { fg = special },
--     LeapLabelPrimary = { fg = bg },
--     LeapLabelSecondary = { fg = bg },
--     LeapLabelSelected = { fg = bg },
--     VM_Mono = { fg = bg },
--     VM_Extend = { bg = selection_inactive },
--     VM_Cursor = { bg = selection_inactive },
--     TelescopePromptBorder = { fg = accent },
--     NeogitDiffContextHighlight = { bg = line },
--     NeogitHunkHeaderHighlight = { bg = line },
--     NvimTreeGitDirty = { fg = accent },
--     NvimTreeFolderIcon = { fg = accent },
--     NvimTreeFolderName = { fg = special },
--     NvimTreeOpenedFolderName = { fg = special },
--     CmdItemKindColor = { fg = special },
--     CmdItemKindFile = { fg = special },
--     CmpItemKindReference = { fg = special },
--     CmpItemKindFolder = { fg = special },
--     DapUIStoppedThread = { fg = special },
--   },
-- })
--
-- -- Configure vim with ayu
-- require('ayu').colorscheme()

-- vim.cmd 'colorscheme material'
-- vim.g.material_style = "darker"
--
require('material').setup({

    contrast = {
        terminal = false, -- Enable contrast for the built-in terminal
        sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = false, -- Enable contrast for floating windows
        cursor_line = false, -- Enable darker background for the cursor line
        non_current_windows = false, -- Enable darker background for non-current windows
        filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
    },

    styles = { -- Give comments style such as bold, italic, underline etc.
        comments = { --[[ italic = true ]] },
        strings = { --[[ bold = true ]] },
        keywords = { --[[ underline = true ]] },
        functions = { --[[ bold = true, undercurl = true ]] },
        variables = {},
        operators = {},
        types = {},
    },

    plugins = { -- Uncomment the plugins that you use to highlight them
        -- Available plugins:
        -- "dap",
        -- "dashboard",
        "gitsigns",
        -- "hop",
        -- "indent-blankline",
        -- "lspsaga",
        "mini",
        -- "neogit",
        -- "neorg",
        -- "nvim-cmp",
        -- "nvim-navic",
        "nvim-tree",
        "nvim-web-devicons",
        -- "sneak",
        "telescope",
        -- "trouble",
        -- "which-key",
    },

    disable = {
        colored_cursor = false, -- Disable the colored cursor
        borders = false, -- Disable borders between verticaly split windows
        background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
        term_colors = false, -- Prevent the theme from setting terminal colors
        eob_lines = false -- Hide the end-of-buffer lines
    },

    high_visibility = {
        lighter = false, -- Enable higher contrast text for lighter style
        darker = false -- Enable higher contrast text for darker style
    },

    lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

    async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)

    custom_colors = nil, -- If you want to everride the default colors, set this to a function

    custom_highlights = {}, -- Overwrite highlights with your own
})

vim.g.material_style = "darker"
vim.cmd 'colorscheme material'

