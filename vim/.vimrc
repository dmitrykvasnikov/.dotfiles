" Plugins
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mg979/coc.nvim', {'branch': 'release'}
"Plug 'bagrat/vim-buffet'
Plug 'ryanoasis/vim-devicons'
"Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'neovimhaskell/haskell-vim'
Plug 'dracula/vim', { 'as' : 'dracula' }
Plug 'sdiehl/vim-ormolu'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

if v:version < 802
    packadd! dracula
endif

" Common settings
let mapleader=" "
set nocompatible
set number relativenumber
set showcmd
set showmatch
set matchtime=2
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set linebreak
set ignorecase
set smartcase
set hidden
set mouse=a
set termguicolors
set cursorline
" let ayucolor="dark"
" set background="dark"
colorscheme dracula
syntax enable
set complete=.,w,b,u
set wildmode=longest,list,full
set splitright
set autoindent
set hlsearch
set incsearch
set signcolumn=yes
set title
set noswapfile
set autowriteall
set so=999
set wildmenu wildoptions+=pum
set path+=**
set suffixesadd+=.hs
hi LineNr guibg=#333644
filetype plugin indent on
set encoding=UTF-8
set backspace=indent,eol,start
hi Normal guibg=#1d2021
hi CursorLine guibg=#333644
hi CursorLineNR guibg=#333644 guifg=#ebdbb2

hi vertsplit guibg=#3c3836 guifg=#3c3836

" Tabline colors settins
hi TabLineFill guifg=#6272a4 guibg=#6272a4
hi TabLineSel guifg=#f8f8f2 guibg=#6272a4
" hi TabLine guifg=#b8b8b8 guibg=#282a36

" Auto-Commands
augroup autosourcing
  autocmd!
  autocmd BufWritePost .vimrc source %
augroup END

augroup vimrc-help-window
  autocmd!
  autocmd BufWinEnter * if &l:buftype ==# "help" | wincmd _ | endif
augroup END

" Ormolu - formatter for Haskell
autocmd BufWritePre *.hs :call RunOrmolu()
let g:ormolu_options=["--no-cabal"]
let g:ormolu_suppress_stderr=1

" Color for non-active splits
hi DimNormal guibg=#282828

" Color for COC error / warning messages
hi! CocErrorSign guifg=#ffb86c
hi! CocInfoSign guibg=#353b45
hi! CocWarningSign guifg=#d1cd66

augroup ActiveWin | au!
    au WinEnter * setl wincolor=
    au WinLeave * setl wincolor=DimNormal
augroup END

" autocmd BufNewFile,BufRead *.hs set filetype=haskell
" autocmd FileType haskell setlocal ts=4 sts=4 sw=4

" Fold markers
set foldmethod=marker
set foldmarker=/\*\*,\*\*/

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

let NERDTreeHijackNetrw=0

" keyboard mappings
nnoremap gs i<CR><ESC>

inoremap <c-space> <esc>
inoremap jj <esc>

cnoremap W w
cnoremap WQ wq

nnoremap <Leader>h :nohlsearch<cr>
nnoremap <Leader>f :NERDTreeToggle<cr>
nnoremap <Leader>o :call RunOrmolu()<cr>

nnoremap <Bs> ciw

nnoremap <tab> gt
nnoremap <S-tab> gT
nnoremap <C-t> :tabnew<cr>

nnoremap <f5> :!ctags -R<cr>
" nnoremap <C-w> :tabclose<cr>
cnoremap <expr> %% getcmdtype() == ':' ? expand ('%:h').'/' : '%%'

" Haskell remaps
nnoremap <Leader>k I-- <ESC>
nnoremap <Leader>l ^df <ESC>

" Splits switch
nnoremap <C-Up> <C-W><C-K>
nnoremap <C-Down> <C-W><C-J>
nnoremap <C-Left> <C-W><C-H>
nnoremap <C-Right> <C-W><C-L>

" Splits resize
nnoremap <A-Left> <C-W><
nnoremap <C-H> <C-W><
nnoremap <A-Right> <C-W>>
nnoremap <C-L> <C-W>>
nnoremap <A-Up> <C-W>+
nnoremap <C-K> <C-W>+
nnoremap <A-Down> <C-W>-
nnoremap <C-J> <C-W>-
nnoremap == <C-W>=

" Buffers
nnoremap <silent> [b :bprevious<cr>
nnoremap <silent> ]b :bnext<cr>
nnoremap <silent> [B :bfirst<cr>
nnoremap <silent> ]B :blast<cr>

" Indentation
nnoremap <S-Left> <<
nnoremap <S-Right> >>
vnoremap <S-Left> <gv
vnoremap <S-Right> >gv

" Registres
" clear default yank register
nnoremap <Leader>d :let @"=""<cr>

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
" let g:buffet_tab_icon = "\uf00a"
" let g:buffet_left_trunc_icon = "\uf0a8"
" let g:buffet_right_trunc_icon = "\uf0a9"
" noremap <Tab> :bn<CR>
" noremap <S-Tab> :bp<CR>

"function! g:BuffetSetCustomColors()
"  hi! BuffetCurrentBuffer cterm=NONE ctermbg=5 ctermfg=8 guibg=#6272a4 guifg=#f8f8f2
"  hi! BuffetBuffer cterm=NONE ctermbg=5 ctermfg=8 guibg=#44475a guifg=#f8f8f2
"  hi! BuffetTab cterm=NONE ctermbg=5 ctermfg=8 guibg=#6272a4 guifg=#f8f8f2
"endfunction

" Commands
command! TagsH !hasktags -x .
command! Tags !ctags -R .

" macros
" -- create fold
" -- let @f="A/**\<CR>**/\<ESC>kA"
" -- move selected lines to fold / in haskell with comment signs
let @f="xi/**\<CR>**/\<CR>\<up>\<ESC>P\<up>A "
let @h="xi-- /**\<CR>**/\<CR>\<BS>\<BS>\<BS>\<up>\<ESC>P\<up>A "
" -- insert function :: undefined
let @u="0yt:o\<ESC>pA= undefined\<CR>\<ESC>"

" To use with vim-airlinie
set noshowmode
" set eventignore=CursorHold,CursorMoved,CursorMovedC,CursorMovedI
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
