set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.config/nvim/plugged')
  Plug 'scrooloose/nerdtree'
  Plug 'itchyny/lightline.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'morhetz/gruvbox'
  Plug 'vim-airline/vim-airline'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

filetype plugin indent on    " required
let mapleader = " "

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
set nu
set wildmenu
set ttyfast
set lazyredraw
set autoread
set mouse=a

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
" Map fzf search to CTRL P
nnoremap <C-p> :GFiles<Cr>
" Map fzf + ag search to CTRL P
nnoremap <C-g> :Ag<Cr>

" set <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
    let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <Tab>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<Tab>" :
          \ coc#refresh()
