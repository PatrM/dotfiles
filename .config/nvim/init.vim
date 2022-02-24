"" Requirements 
" vim-plug:
"   https://github.com/junegunn/vim-plug
" :Rg (Ripgrep):
"   Ubuntu/WSL: https://gist.github.com/kostaz/6e0cf1eee35a34cd6589ec15b58e682c
"   https://github.com/BurntSushi/ripgrep#installation for OSX
""

set nocompatible
filetype off

" maybe migrate to https://github.com/wbthomason/packer.nvim "
call plug#begin('~/.config/nvim/plugged')
  Plug 'scrooloose/nerdtree'
  Plug 'itchyny/lightline.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'morhetz/gruvbox'
  Plug 'neovim/nvim-lspconfig'
  Plug 'vim-airline/vim-airline'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'puremourning/vimspector'
  Plug 'tveskag/nvim-blame-line'
call plug#end()
filetype plugin indent on    " required

" https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
lua << EOF
require'lspconfig'.pyright.setup{}
require'lspconfig'.angularls.setup{}

EOF


"" NERDTree
nmap <F6> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeNodeDelimiter = "\u00a0"

syntax on
syntax enable
colorscheme gruvbox
set termguicolors

" Indenting, 2 spaces per tab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set cindent
set smartindent
set number relativenumber
set nu rnu
set wildmenu
set ttyfast
set lazyredraw
set autoread
set mouse=a
set ignorecase
set smartcase
" folding
set foldmethod=syntax
set foldlevel=99
nmap z za

" Disable backups and swapping
set nobackup
set nowritebackup
set noswapfile

set ignorecase
set smartcase
set incsearch

" Allow copy & paste from system clipboard
set clipboard=unnamed

" Delete characters outside of insert area
set backspace=indent,eol,start

" If fzf installed using git
set rtp+=~/.fzf

set updatetime=300


"===== Keymappings =======
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
" Use <c-space> to trigger completion.

" Map fzf search to CTRL P
map <expr> <C-p> fugitive#head() != '' ? ':GFiles --cached --others --exclude-standard<CR>' : ':Files<CR>'

" Map fzf + ag search to CTRL P
nnoremap <C-g> :Ag<Cr>
" Bind enter to cancel search highlighting
nnoremap <CR> :noh<Cr>
" Mapp buffers to CTRL e (intellij-like)
nnoremap <C-e> :Buffers<Cr>

" Vimspector
let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-java-debug' ]
let g:vimspector_enable_mappings = 'HUMAN'
nmap <F1> :CocCommand java.debug.vimspector.start<CR>
