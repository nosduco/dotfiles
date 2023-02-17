-- Setup Options
require("options")

-- Install Plugins
require("plugins")

-- Configure Plugins
require("plugins/tree")
require("plugins/finder")
require("plugins/comments")
require("plugins/lsp")
require("plugins/util")

-- Apply Themes
require("theme")

-- Configure Plugins (dependent on theme)
require("plugins/lualine")

-- Configure GUI editors
require("neovide")
