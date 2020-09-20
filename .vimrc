set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.config/nvim/plugged')
  Plug 'scrooloose/nerdtree'
  Plug 'mattn/emmet-vim'
  Plug 'joshdick/onedark.vim'
  Plug 'itchyny/lightline.vim'
  Plug 'airblade/vim-gitgutter'     
  Plug 'tpope/vim-fugitive'         
  Plug 'posva/vim-vue'
  Plug 'pangloss/vim-javascript'    
  Plug 'leafgarland/typescript-vim' 
  Plug 'styled-components/vim-styled-components'
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
colorscheme onedark

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

" Add CoC Prettier if prettier is installed
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

" Add CoC ESLint if ESLint is installed
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif
