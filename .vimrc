syntax on
filetype off
set nocompatible
set encoding=utf-8
set autochdir
set omnifunc=syntaxcomplete#Complete

set nu rnu
set ruler
set novisualbell
set noerrorbells 
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set scrolloff=3

set undodir=~/.vim/undodir
set undofile

set colorcolumn=100
set signcolumn=yes

set matchpairs+=<:> 
set hidden
set ttyfast
set laststatus=2
set showmode
set showcmd

set tags=tags;/ 

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set listchars=tab:▸\ ,eol:¬

highlight Colorcolumn ctermbg=0 guibg=lightgrey

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'mbbill/undotree'
Plugin 'morhetz/gruvbox'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'shinchu/lightline-gruvbox.vim'
Plugin 'ervandew/supertab'
call vundle#end()
filetype plugin indent on
let mapleader = " "

"COLORSCHEME{{{
colorscheme gruvbox
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark
"}}}

" LIGHTLINE: {{{
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
      \ }
      \ }
" }}}


" REMAP : {{{ 
nnoremap <C-b> :make<CR>
"Navigation entre fenetre
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
"UndoTree
nnoremap <leader>u :UndotreeShow<CR>
"Exploration Project view et Project search
let NERDTreeWinSize = 25
nnoremap <leader>pv :NERDTreeFind<CR>
"nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Ack<SPACE>
nnoremap <leader>sw :Ack *<CR>
"Resize
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
"
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

vnoremap <Leader>a y:Ack <C-r>=fnameescape(@")<CR><CR>
"
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
"Jumps
nnoremap <Leader>j :jumps<CR>
"Tab navigation
nnoremap <leader>t gt
nnoremap <leader>T gT
"}}}
