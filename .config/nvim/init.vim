"" Requirements 
" vim-plug:
"   https://github.com/junegunn/vim-plug
" :Rg (Ripgrep):
"   Ubuntu/WSL: https://gist.github.com/kostaz/6e0cf1eee35a34cd6589ec15b58e682c
"   https://github.com/BurntSushi/ripgrep#installation for OSX
""

set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')
  Plug 'scrooloose/nerdtree'
  Plug 'itchyny/lightline.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'liuchengxu/vim-which-key'
  Plug 'tpope/vim-fugitive'
  Plug 'morhetz/gruvbox'
  Plug 'vim-airline/vim-airline'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
filetype plugin indent on    " required

  let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-actions',
    \ 'coc-java-debug',
    \ 'coc-java',
    \ 'coc-lists',
    \ 'coc-emmet',
    \ 'coc-tasks',
    \ 'coc-pairs',
    \ 'coc-tsserver',
    \ 'coc-floaterm',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-cssmodules',
    \ 'coc-yaml',
    \ 'coc-python',
    \ 'coc-pyright',
    \ 'coc-svg',
    \ 'coc-prettier',
    \ 'coc-vimlsp',
    \ 'coc-xml',
    \ 'coc-yank',
    \ 'coc-json',
    \ 'coc-marketplace',
    \ ]


"" NERDTree
nmap <F6> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '‚ñ∏'
let g:NERDTreeDirArrowCollapsible = '‚ñæ'
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

"" CoC related stuff below
""""""""""""""""""""""""""

" set <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
    let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <Tab>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<Tab>" :
          \ coc#refresh()

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

"===== Keymappings =======
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Use K to show documentation in preview window.
nnoremap <leader>d :call <SID>show_documentation()<CR>
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Map fzf search to CTRL P
nnoremap <C-p> :GFiles<Cr>
" Map fzf + ag search to CTRL P
nnoremap <C-g> :Ag<Cr>
" Bind enter to cancel search highlighting
nnoremap <CR> :noh<Cr>
" Mapp buffers to CTRL e (intellij-like)
nnoremap <C-e> :Buffers<Cr>
" Searching / Refactoring
nnoremap <leader>? CocSearch <C-R>=expand("<cword>")<CR><CR>
" Which-Key config
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
set timeoutlen=500
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
let g:which_key_map =  {}
let g:which_key_map['?'] = 'search word'


let g:which_key_map.l = {
  \ 'name' : '+lsp' ,
  \ 'R' : ['<Plug>(coc-rename)', 'rename'],
  \ }
