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
" set spell
set shortmess=a
let g:bufferline_echo=0
set cmdheight=1
filetype plugin indent on   

" Ctrl+movement
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l

" Tab keybinds
nnoremap <C-t>     :tabnew<CR>
inoremap <C-t>     <Esc>:tabnew<CR>

" Mouse Support
set mouse=a

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

" Install vim-plug if not exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" START PLUGINS
call plug#begin('~/.vim/plugged')

" Utilities
Plug 'ap/vim-css-color'
Plug 'tpope/vim-surround'

" Navigation
Plug 'christoomey/vim-tmux-navigator'

" Git
Plug 'tpope/vim-fugitive'

" Files
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Comments
Plug 'scrooloose/nerdcommenter'

" JavaScript and Typescript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'

" Golang
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Markup
Plug 'othree/xml.vim'

" COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Theming
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'luochen1990/rainbow'

call plug#end()
" END PLUGINS

" ; for fuzzy find file
map <space> :Files<CR>

" Ctrl+F for ESLint Auto Fix
" nmap <C-F> :call CocActionAsync('runCommand', 'eslint.executeAutofix')<CR>
nmap <C-F> :call CocActionAsync('format')<CR>

" Ctrl+I for Code Autocomplete
nmap <C-I> <Plug>(coc-codeaction)

" Show autocomplete on Tab
" inoremap <silent><expr> <S-Tab> coc#refresh()
" nnoremap <S-Tab> coc#refresh()


" COC Configuration
inoremap <silent><expr> <c-space> coc#refresh()
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
let g:coc_global_extensions = ['coc-yank', 'coc-spell-checker', 'coc-snippets', 'coc-prettier', 'coc-json', 'coc-html', 'coc-highlight', 'coc-git', 'coc-eslint', 'coc-yaml', 'coc-xml', 'coc-tsserver', 'coc-sh', 'coc-python', 'coc-omnisharp', 'coc-markdownlint', 'coc-java', 'coc-css']

" GoTo Code Nav
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Turn on rainbow parenthesis
let g:rainbow_active = 1

" Fix for NERDTree rainbow parenthesis collision
let g:rainbow_conf = {
\	'separately': {
\		'nerdtree': 0,
\	}
\}

" NERDTree Config
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.meta$']
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeMapOpenInTab='t'
let g:NERDTreeChDirMode = 2
set lazyredraw

" NERDCommenter Config
let g:NERDSpaceDelims = 1
inoremap <C-_> :call NERDComment(0,"toggle")<CR>
vnoremap <C-_> :call NERDComment(0,"toggle")<CR>
nnoremap <C-_> :call NERDComment(0,"toggle")<CR>

" Fuzzy Finder
" let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" Themeing
syntax enable
set t_Co=256
set termguicolors
let ayucolor="dark"
colorscheme ayu
let g:airline_powerline_fonts = 1
let g:airline_theme = "distinguished"
let g:airline#extensions#tabline#enabled = 1
let s:green = "AE403F"
highlight Directory ctermfg=5
hi Normal guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight ExtraWhitespace guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
