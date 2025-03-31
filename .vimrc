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
set formatoptions-=cro
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set scrolloff=3
set directory^=$HOME/.vim/tmp//

set undodir=~/.vim/undodir
set undofile

set colorcolumn=100
set signcolumn=yes

set matchpairs+=<:> 
set ttyfast
set hidden
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

set foldmethod=syntax
set completeopt+=preview 
set completeopt+=menuone
highlight Colorcolumn ctermbg=0 guibg=lightgrey

call plug#begin()
    Plug 'will133/vim-dirdiff'
    Plug 'mbbill/undotree'
    Plug 'pineapplegiant/spaceduck'
    Plug 'mileszs/ack.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'scrooloose/nerdtree'
    Plug 'vim-scripts/DoxygenToolkit.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'sheerun/vim-polyglot'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'vim-airline/vim-airline'
    Plug 'levelone/tequila-sunrise.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'dense-analysis/ale'
call plug#end()

filetype plugin indent on
let mapleader = " "

if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\  
endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
colorscheme spaceduck

" LIGHTLINE: {{{
    let g:lightline = {
          \ 'colorscheme': 'spaceduck',
          \ 'active' : {
          \     'left':[ [ 'mode', 'paste' ],
          \              ['readonly', 'absolutepath','modified'],
          \              ['readonly', 'funcPreview'] ]
          \ },
          \ 'component_function' : {
          \     'funcPreview' : 'FuncPreview'
          \ },
          \ }
" }}}


"Syntax

let g:cpp_function_highlight = 1
let g:cpp_attributes_higlight = 1
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1

"ALE{{{
let g:ale_linters = {'cpp': ['clang']}
"}}}
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
nnoremap <leader>nt :NERDTreeFind<CR>
nnoremap <leader>root :0tabnew .<CR>
"deactivate higliht when not searching
nnoremap <CR> :noh<CR><CR>
"nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Ack<SPACE>
nnoremap <leader>sw :Ack *<CR>
"Resize
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>
"follow tag in a new tab
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
"RipGrep :
"Word under the cursor
nnoremap <leader>rg :Rg <C-r><C-w><CR>
let g:fzf_vim = {}
let g:fzf_vim.buffers_jump = 0
"Line Move
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
"Jumps
nnoremap <Leader>J :jumps<CR>
"Tab navigation
nnoremap <leader>t gt
nnoremap <leader>T gT
"Buffer navigation
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bn :bp<CR>
nnoremap <leader>bb :Buffers<CR>
"Git Macro
nnoremap <leader>gd :call GitDiff()<cr>

"Doxygene
nnoremap <leader>d :Dox<cr>


"}}}


" FUNCTION : {{{
"Current function name
function FuncPreview()
  let opening = search("^\\S.*)\\s*\\\(\\n\\\)\\={","bn")
  let closing = search("^}","bn")
  if opening > closing
    return getline(opening)
  else
    return ""
  endif
endfunction

function GitDiff()
    :silent write
    :silent execute '!git diff --color=always -- ' . expand('%:p') . ' | less --RAW-CONTROL-CHARS'
    :redraw!
endfunction

