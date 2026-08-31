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
set conceallevel=2

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
    Plug 'dpelle/vim-LanguageTool'
    Plug 'ArthurSonzogni/Diagon'
    Plug 'wiwiiwiii/vim-diagon'
    Plug 'nvim-lua/plenary.nvim' 
    Plug 'obsidian-nvim/obsidian.nvim'
    Plug 'meanderingprogrammer/render-markdown.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'echasnovski/mini.pick'
Plug 'echasnovski/mini.extra'
call plug#end()


lua << EOF

require('mini.pick').setup()
require('mini.extra').setup()
require('obsidian').setup({
  workspaces = {
    { name = 'notes', path = '/home/pasainrat/vaults/notes-perso' },
  },
  legacy_commands = false,
})

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = {
    'clangd',
    '--background-index',
    '--query-driver=/usr/bin/arm-none-eabi-*',
  },
})

vim.lsp.enable('clangd')
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', '<C-\\>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>ss', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    local pick_lsp = require('mini.extra').pickers.lsp

    vim.keymap.set('n', '<C-\\>', function() pick_lsp({ scope = 'definition' }) end, opts)
    vim.keymap.set('n', 'gD', function() pick_lsp({ scope = 'declaration' }) end, opts)
    vim.keymap.set('n', 'gr', function() pick_lsp({ scope = 'references' }) end, opts)
    vim.keymap.set('n', 'gi', function() pick_lsp({ scope = 'implementation' }) end, opts)
    vim.keymap.set('n', 'gy', function() pick_lsp({ scope = 'type_definition' }) end, opts)
    vim.keymap.set('n', '<leader>ss', function() pick_lsp({ scope = 'workspace_symbol' }) end, opts)

    -- unchanged
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  end,
})

require('mini.pick').setup({
  mappings = {
    move_down = '<C-j>',
    move_up = '<C-k>',
  },
})

EOF

set spelllang=fr
let g:languagetool_jar='/home/pasainrat/language/LanguageTool-5.2/languagetool-commandline.jar'
"let g:languagetool_lang='fr'


nnoremap <leader>ltc  :LanguageToolCheck <CR>
nnoremap <leader>ltcl :LanguageToolClear <CR>



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
let g:ale_c_parse_makefile = 1
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
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bb :Buffers<CR>
"Git Macro
nnoremap <leader>gd :call GitDiff()<cr>
nnoremap <leader>gdh :diffget //2<CR>
nnoremap <leader>gdl :diffget //3<CR>

"Doxygene
nnoremap <leader>d :Dox<cr>

"Markdowm
let g:notesium_bin='notesium-linux-amd64'
let g:NOTESIUM_DIR='/home/pasainrat/Note'

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

