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
set encoding=UTF-8

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


" Vim-Buffet
" let g:buffet_powerline_separators = 1
let g:buffet_tab_icon = "\uf00a"
" let g:buffet_left_trunc_icon = "\uf0a8"
" let g:buffet_right_trunc_icon = "\uf0a9"
noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>

function! g:BuffetSetCustomColors()
  hi! BuffetCurrentBuffer cterm=NONE ctermbg=5 ctermfg=8 guibg=#458588 guifg=#ffffff
  hi! BuffetBuffer cterm=NONE ctermbg=5 ctermfg=8 guibg=#3c3836 guifg=#ffffff
  hi! BuffetTab cterm=NONE ctermbg=5 ctermfg=8 guibg=#458588 guifg=#ffffff
endfunction

" Commands
command! TagsH !hasktags -x .
command! Tags !ctags -R .

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'bagrat/vim-buffet'
Plug 'ryanoasis/vim-devicons'
call plug#end()
