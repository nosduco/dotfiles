" Setup
set nocompatible
filetype off         
syntax on
set tabstop=4 shiftwidth=4 expandtab
set number
set laststatus=2

" testing...
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

nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l





set rtp+=~/.vim/bundle/Vundle.vim
" Mouse Support
set mouse=a


" Vundle Plugins

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ap/vim-css-color'
Plugin 'othree/xml.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

" Auto-completion
Plugin 'OmniSharp/omnisharp-vim'
Plugin 'tpope/vim-dispatch'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()            

" Plugin Configuration
map <C-n> :NERDTreeToggle<CR>


" Themeing

syntax enable
set background=dark
colorscheme jellybeans 

set shortmess=a
let g:bufferline_echo=0
set cmdheight=2

filetype plugin indent on   

let g:airline_powerline_fonts = 1
let g:airline_theme = "distinguished"

let NERDTreeIgnore = ['\.meta$']

"YCM Config

"let g:ycm_global_ycm_extra_conf = '/usr/share/vim/vimfiles/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"let g:ycm_server_python_interpretor = 'python2.7'

set t_Co=256
