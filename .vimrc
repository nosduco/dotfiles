" Setup
set nocompatible
filetype off         
syntax on
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set number
set laststatus=2

" TMUX Fix
set ttimeoutlen=0

" Personal preferences
set nowrap
set showcmd
set showmatch
set incsearch
set hlsearch
set ignorecase smartcase
set directory=/tmp/
set autoread
set autoindent
set display=lastline
set splitright
set splitbelow
set spell
set shortmess=a
let g:bufferline_echo=0
set cmdheight=1
filetype plugin indent on   

" Ctrl+movement
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

" Vundle Support
set rtp+=~/.vim/bundle/Vundle.vim

" Mouse Support
set mouse=a

" Vundle Plugins
call vundle#begin()

" Generic Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'ryanoasis/vim-devicons'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ap/vim-css-color'
Plugin 'othree/xml.vim'

" JavaScript
Plugin 'mxw/vim-jsx'
Plugin 'othree/yajs.vim'
Plugin 'dense-analysis/ale'
" Plugin 'pangloss/vim-javascript'
" Plugin 'isruslan/vim-es6'
" Plugin 'maksimr/vim-jsbeautify'

" Auto-completion
Plugin 'OmniSharp/omnisharp-vim'
Plugin 'tpope/vim-dispatch'
" Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'

" Themeing
Plugin 'mhartington/oceanic-next'

call vundle#end()            

" Javascript Config 
let g:ale_linters = {
            \    'javascript': ['eslint', 'prettier'],
            \    'scss': ['prettier']
            \}
let g:ale_fixers = {
  \'javascript': ['eslint', 'prettier'],
  \'scss': ['prettier']
  \}

let g:ale_fix_on_save = 1

" NERDTree Config
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.meta$']
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1
let g:NERDTreeChDirMode = 2

" NERDCommenter Config
let g:NERDSpaceDelims = 1
inoremap <C-_> :call NERDComment(0,"toggle")<CR>
vnoremap <C-_> :call NERDComment(0,"toggle")<CR>
nnoremap <C-_> :call NERDComment(0,"toggle")<CR>

" ALE Key  
nmap <C-F> <Plug>(ale_fix)

" Themeing
syntax enable
set t_Co=256
" if exists('+termguicolors')
  " let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  " set termguicolors
" endif
colorscheme OceanicNext
highlight Directory ctermfg=5

" colorscheme jellybeans 

" set background=dark
let g:airline_powerline_fonts = 1
let g:airline_theme = "distinguished"
let s:green = "AE403F"

hi Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight ExtraWhitespace guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE

