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

" Use system clipboard
set clipboard+=unnamedplus

" Vertically center documnent entering insert mode
autocmd InsertEnter * norm zz

" Removing trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Alias replace all to S
nnoremap S :%s//gI<Left><Left><Left>

inoremap <c-space> <esc>

