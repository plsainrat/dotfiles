syntax on
filetype off
set nocompatible
set encoding=utf-8
set autochdir

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

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set listchars=tab:▸\ ,eol:¬

highlight Colorcolumn ctermbg=0 guibg=lightgrey

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'oblitum/youcompleteme'
Plugin 'mbbill/undotree'
Plugin 'dense-analysis/ale'
Plugin 'morhetz/gruvbox'
Plugin 'scrooloose/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'shinchu/lightline-gruvbox.vim'
Plugin 'Maximbaz/lightline-ale'
call vundle#end()
filetype plugin indent on
let mapleader = " "
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/youcompleteme/ycm_global_conf.py"
"
"ColorScheme
colorscheme gruvbox
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

" ALE: {{{
let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'
let g:ale_sign_info = '·'
let g:ale_sign_style_error = '·'
let g:ale_sign_style_warning = '·'
let b:ale_linters = { 'c': ['clang']}
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
"Resize
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
"}}}









