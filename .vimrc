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

" Mouse Support
set mouse=a

" COC
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
set signcolumn=yes
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
nmap <C-S-F>  <Plug>(coc-fix-current)
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>

" Install vim-plug if not exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')

" Generic Plugins
Plug 'scrooloose/nerdtree'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ap/vim-css-color'
Plug 'othree/xml.vim'

" JavaScript
Plug 'mxw/vim-jsx'
Plug 'othree/yajs.vim'
Plug 'briancollins/vim-jst'

" COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Themeing
Plug 'ayu-theme/ayu-vim'

call plug#end()
" END PLUGINS

" ALE Config
let g:ale_linters = {
            \    'javascript': ['eslint', 'prettier'],
            \    'scss': ['prettier'],
            \    'python': ['flake8', 'pylint']
            \}
let g:ale_fixers = {
  \'javascript': ['eslint', 'prettier'],
  \'scss': ['prettier'],
  \'python': ['autopep8', 'yapf']
  \}

let g:ale_fix_on_save = 1
nmap <C-F> <Plug>(ale_fix)

" NERDTree Config
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.meta$']
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1
let g:NERDTreeChDirMode = 2

set lazyredraw

" NERDCommenter Config
let g:NERDSpaceDelims = 1
inoremap <C-_> :call NERDComment(0,"toggle")<CR>
vnoremap <C-_> :call NERDComment(0,"toggle")<CR>
nnoremap <C-_> :call NERDComment(0,"toggle")<CR>

" Themeing
syntax enable
set t_Co=256


set termguicolors
let ayucolor="mirage"
colorscheme ayu
"
"
"
let g:airline_powerline_fonts = 1
let g:airline_theme = "distinguished"
let s:green = "AE403F"
highlight Directory ctermfg=5
hi Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight ExtraWhitespace guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE

