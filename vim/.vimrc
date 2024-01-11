" Common settings
set nocompatible
set number relativenumber
set tabstop=2
set expandtab
set linebreak
set ignorecase
set smartcase
set hidden
set mouse=a
set termguicolors
set cursorline
colorscheme gruvbox
set bg=dark
syntax on
set wildmode=longest,list,full
set splitbelow splitright
set autoindent
set hlsearch
set title
set noswapfile
set wildmenu wildoptions+=pum
set path+=**

" Use system clipboard
set clipboard+=unnamedplus

" Vertically center documnent entering insert mode
autocmd InsertEnter * norm zz

" Removing trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Alias replace all to S
nnoremap S :%s//gI<Left><Left><Left>

" file explorer
let g:netrw_winsize = 30
let g:netrw_banner = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_keepdir = 0

" keyboard mappings
inoremap <c-space> <esc>
inoremap jj <esc>

cnoremap W w
cnoremap WQ wq

