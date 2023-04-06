local M = {}

M.treesitter = {
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
		"javascript",
		"typescript",
		"rust",
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

M.mason = {
	ensure_installed = {
		-- Lua
		"lua-language-server",
		"stylua",

		-- Docker
		"docker-compose-language-service",
		"dockerfile-language-server",

		-- Web
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"eslint_d",
		"prettier",
		"prisma-language-server",

		-- Rust
		"rust-analyzer",
		"rustfmt",

		-- Python
		"pyright",

		-- Terraform
		"terraform-ls",

    -- Github actions
    "actionlint",

    -- Yaml
    "yaml-language-server",

		-- Misc
		"cspell",
	},
}

M.nvimtree = {
	git = {
		enable = true,
    ignore = false,
	},
	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "s", action = "vsplit" },
				{ key = "i", action = "split" },
				{ key = "u", action = "dir_up" },
			},
		},
	},
	actions = {
		open_file = {
			quit_on_open = true,
			window_picker = {
				enable = false,
			},
		},
	},
}

local luasnip = require("luasnip")
local cmp = require("cmp")
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.cmp = {
	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
}

M.toggleterm = {
	open_mapping = [[<c-t>]],
	insert_mappings = true,
	terminal_mappings = true,
	direction = "vertical",
	close_on_exit = true,
	size = vim.o.columns * 0.25,
}

return M
