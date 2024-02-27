" Common settings
set nocompatible
set number relativenumber
set tabstop=2
set shiftwidth=2
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
syntax enable
set wildmode=longest,list,full
set splitbelow splitright
set autoindent
set hlsearch
set title
set noswapfile
set wildmenu wildoptions+=pum
set path+=**
hi LineNr guibg=#333644
filetype plugin on

" Use system clipboard
set clipboard+=unnamedplus

" Vertically center documnent entering insert mode
autocmd InsertEnter * norm zz

" Removing trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Alias replace all to S
nnoremap S :%s//gI<Left><Left><Left>

" file explorer
let g:netrw_winsize=30
let g:netrw_banner=0
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
let g:netrw_keepdir=0
let g:netrw_liststyle=3

" keyboard mappings
nnoremap gs i<CR><ESC>

inoremap <c-space> <esc>
inoremap jj <esc>

cnoremap W w
cnoremap WQ wq

cnoremap ce CocEnable
cnoremap cd CocDisable

" CoC
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
let g:coc_snippet_next = '<Tab>'

" use <tab> to trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Commands
command! TagsH !hasktags -x .
command! Tags !ctags -R .
