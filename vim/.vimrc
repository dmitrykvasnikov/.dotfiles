" Plugins
call plug#begin('~/.vim/plugged')
"Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovimhaskell/haskell-vim'
Plug 'sdiehl/vim-ormolu'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-unimpaired'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
"Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'scrooloose/nerdtree'
Plug 'dracula/vim', { 'as' : 'dracula' }
Plug 'nbouscal/vim-stylish-haskell'
"Plug 'bagrat/vim-buffet'
"Plug 'tpope/vim-vinegar'
"Plug 'tpope/vim-surround'
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
set modifiable
hi Normal guibg=#1d2021
hi CursorLine guibg=#333644
hi CursorLineNR guibg=#333644 guifg=#ebdbb2

" Cursors for different modes
let &t_SI="\<Esc>[5 q"
let &t_SR="\<Esc>[4 q"
let &t_EI="\<Esc>[2 q"

hi vertsplit guibg=#3c3836 guifg=#3c3836

" Color for non-active splits
hi DimNormal guibg=#282828

" Auto-Commands
augroup autosourcing
  autocmd!
  autocmd BufWritePost .vimrc source %
augroup END

"augroup vimrc-help-window
  "autocmd!
  "autocmd BufWinEnter * if &l:buftype ==# "help" | wincmd _ | endif
"augroup END

" Ormolu - formatter for Haskell
autocmd BufWritePre *.hs :call RunOrmolu()
let g:ormolu_options=["--no-cabal"]
let g:ormolu_suppress_stderr=1



augroup ActiveWin | au!
    au WinEnter * setl wincolor=
    au WinLeave * setl wincolor=DimNormal
augroup END

" autocmd BufNewFile,BufRead *.hs set filetype=haskell
" autocmd FileType haskell setlocal ts=4 sts=4 sw=4

" Fold markers
set foldmethod=marker
set foldmarker=/\*\*,\*\*/

" Vertically center documnent entering insert mode
"autocmd InsertEnter * norm zz

" Removing trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Alias replace all to S
nnoremap S :%s//gI<Left><Left><Left>


" keyboard mappings
"combine & split lines
nnoremap gs i<CR><ESC>
nnoremap gj jI<bs><ESC>

nnoremap <S-u> jI<bs><ESC>

inoremap <c-space> <esc>
inoremap jj <esc>

"cnoremap W w
"cnoremap WQ wq

nnoremap <Leader>h :nohlsearch<cr>
nnoremap <Leader>r :source ~/.vimrc<cr>:noh<cr>

nnoremap <Bs> ciw

nnoremap <f5> :!ctags -R<cr>
cnoremap <expr> %% getcmdtype() == ':' ? expand ('%:h').'/' : '%%'

" Haskell remaps
" add / remove -- comments in the begining of the line / selected lines
nnoremap <Leader>k I-- <ESC>
nnoremap <Leader>l ^df <ESC>
vnoremap <Leader>k :normal 0i-- <cr>
vnoremap <Leader>l :normal 03x<cr>
nnoremap <Leader>cb :!cabal build<cr>

" close / create buffers
nnoremap <Leader>w :bd<cr>
nnoremap <Leader>t :enew<cr>

" copy / paste with xclip
vnoremap <Leader>c :!xclip -f -sel clip<CR>
nnoremap <Leader>v :-1r !xclip -o -sel clip<CR>


" Bubbling visually selected lines
vnoremap <C-Up> xkP`[V`]
vnoremap <C-Down> xp`[V`]

" Splits switch
nnoremap <S-K> <C-W><C-K>
nnoremap <S-J> <C-W><C-J>
nnoremap <S-H> <C-W><C-H>
nnoremap <S-L> <C-W><C-L>

" Splits resize
nnoremap <C-H> <C-W><
nnoremap <C-L> <C-W>>
nnoremap <C-K> <C-W>+
nnoremap <C-J> <C-W>-
nnoremap == <C-W>=

" Buffers
nnoremap <silent> < :bprevious<cr>
nnoremap <silent> > :bnext<cr>
nnoremap <silent> [b :bprevious<cr>
nnoremap <silent> ]b :bnext<cr>
nnoremap <silent> [B :bfirst<cr>
nnoremap <silent> ]B :blast<cr>

" Indentation
nnoremap <C-Left> <<
nnoremap <C-Right> >>
vnoremap <C-Left> <gv
vnoremap <C-Right> >gv

" Yand
vnoremap y y`]

" Show syntax group
nmap <Leader>s :call <SID>SynStack()<CR>

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

" Color for COC error / warning messages
hi! CocErrorSign guifg=#ffb86c
hi! CocErrorFloat guifg=#ffb86c
hi! CocErrorHighlight guifg=#339933
"hi! CocInfoSign guibg=#353b45
"hi! CocWarningSign guifg=#d1cd66

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
" Enable the list of buffers
" let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

augroup HITABFILL
    autocmd!
    autocmd User AirlineAfterInit hi airline_tabfill guibg=#282a36
    autocmd User AirlineAfterInit hi airline_tabsel guibg=#6272a4 guifg=#f8f8f2
    autocmd User AirlineAfterInit hi airline_tabhid guibg=#282a36 guifg=#b8b8b8
augroup END

" Tabline settings
"function! Tabline()
  "let s = ''
  "for i in range(tabpagenr('$'))
    "let tab = i + 1
    "let winnr = tabpagewinnr(tab)
    "let buflist = tabpagebuflist(tab)
    "let bufnr = buflist[winnr - 1]
    "let bufname = bufname(bufnr)
    "let bufmodified = getbufvar(bufnr, "&mod")
"
    "let s .= '%' . tab . 'T'
    "let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    "let s .= ' ' . tab .':'
    "let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . ']' : '[No Name]')
"
    "if bufmodified
      "let s .= '+'
    "else
      "let s .= ' '
    "endif
"
  "endfor
"
  "let s .= '%#TabLineFill#'
"  if (exists("g:tablineclosebutton"))
"    let s .= '%=%999XX'
"  endif
  "return s
"endfunction
"set tabline=%!Tabline()

" hi TabLineFill guifg=#6272a4 guibg=#6272a4
" hi TabLineSel guifg=#f8f8f2 guibg=#6272a4
" hi TabLine term=NONE cterm=NONE gui=NONE guifg=#b8b8b8 guibg=#282a36

" NERDTree plugin
"let g:netrw_winsize=30
"let g:netrw_banner=0
"let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+'
"let g:netrw_keepdir=0
"let g:netrw_liststyle=3
"let NERDTreeHijackNetrw=0
"nnoremap <Leader>nt :NERDTreeToggle<cr>
"nnoremap <Leader>o :call RunOrmolu()<cr>

" FZF plugin
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>m :Marks<cr>
nnoremap <Leader>j :Jumps<cr>
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--pointer=->', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)
command! -bang -nargs=? -complete=dir Buffers
   \ call fzf#vim#buffers(<q-args>, {'options': ['--layout=reverse', '--pointer=->']}, <bang>0)
command! -bang -nargs=? -complete=dir Maps
   \ call fzf#vim#maps(<q-args>, {'options': ['--layout=reverse', '--pointer=->']}, <bang>0)
command! -bang -nargs=? -complete=dir Jumps
   \ call fzf#vim#jumps({'options': ['--layout=reverse', '--pointer=->']}, <bang>0)
command! -bang -nargs=? -complete=dir Marks
   \ call fzf#vim#marks({'options': ['--layout=reverse', '--pointer=->']}, <bang>0)
" Show highlihgt group for current world
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'),col('.')), 'synIDattr(v:val, "name")')
endfunc

