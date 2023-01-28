return require('packer').startup(function(use)
  -- Packer (Plugin/Package Manager)
  use 'wbthomason/packer.nvim'

  -- CSS
  -- use 'ap/vim-css-color'
  use 'norcalli/nvim-colorizer.lua'

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

  -- Themes
  use { 'catppuccin/nvim', as = 'catppuccin' }
end)

