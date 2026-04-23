vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Load plugins
require("lazy").setup({
  { import = "plugins" },
}, lazy_config)

-- Load colorscheme
vim.cmd.colorscheme "catppuccin-mocha"

-- Load options
require "options"

-- Autocmds
local autocmd = vim.api.nvim_create_autocmd

-- Treesitter: enable highlight, folds, and indent per filetype (main-branch API)
local ts_config = require "configs.treesitter"
autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    if not ts_config.indent_disabled[vim.bo[args.buf].filetype] then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Load mappings (deferred to avoid conflicts)
vim.schedule(function()
  require "mappings"
end)
