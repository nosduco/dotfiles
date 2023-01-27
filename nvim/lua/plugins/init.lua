return require('packer').startup(function(use)
  -- use 'wbthomason/packer.nvim'

  -- CSS
  use 'ap/vim-css-color'

  -- Tmux Navigation 
  use 'christoomey/vim-tmux-navigator'

  -- Files
  use 'nvim-tree/nvim-web-devicons'
  use {'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' }}
  use {'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { {'nvim-lua/plenary.nvim'} } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

  -- Tabs/Buffers
  use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}

  -- Comments
  use { 'echasnovski/mini.comment', branch = 'stable' }

  -- Airline
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }

  -- Extension Host/Language Server
  use {'neoclide/coc.nvim', branch = 'release'}

  -- Language Server
  -- use {
  --   'VonHeikemen/lsp-zero.nvim',
  --   branch = 'v1.x',
  --   requires = {
  --     -- LSP Support
  --     {'neovim/nvim-lspconfig'},             -- Required
  --     {'williamboman/mason.nvim'},           -- Optional
  --     {'williamboman/mason-lspconfig.nvim'}, -- Optional
  --
  --     -- Autocompletion
  --     {'hrsh7th/nvim-cmp'},         -- Required
  --     {'hrsh7th/cmp-nvim-lsp'},     -- Required
  --     {'hrsh7th/cmp-buffer'},       -- Optional
  --     {'hrsh7th/cmp-path'},         -- Optional
  --     {'saadparwaiz1/cmp_luasnip'}, -- Optional
  --     {'hrsh7th/cmp-nvim-lua'},     -- Optional
  --
  --     -- Snippets
  --     {'L3MON4D3/LuaSnip'},             -- Required
  --     {'rafamadriz/friendly-snippets'}, -- Optional
  --   }
  -- }

  -- Themes
  use { "ellisonleao/gruvbox.nvim" }
end)

