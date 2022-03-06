-- clone packer if it doesn't exist yet
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'
  use 'morhetz/gruvbox'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'kyazdani42/nvim-web-devicons'
  use 'mfussenegger/nvim-jdtls'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'tveskag/nvim-blame-line'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lua'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'

end)


-- https://www.notonlycode.org/neovim-lua-config/

require('nvim-lsp-config')
require('telescope-config')
--------------------------- tree sitter
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing
  ignore_install = { "javascript" },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
--------------------------- tree sitter END




--------------------------- icons
require'nvim-web-devicons'.setup {
 default = true;
}
--------------------------- icons END



------- MIGRATION FROM init.vim STUFF BELOW
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd> lua require('telescope.builtin').livegrep()<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd> lua require('telescope.builtin').buffers()<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd> lua require('telescope.builtin').help_tags()<cr>", {noremap = true})
vim.g.mapleader = ";"
vim.cmd "colorscheme gruvbox"
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wildmode = {'full'}
vim.wo.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.foldmethod = "syntax"
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.clipboard = "unnamed"


-- Bind enter to cancel search highlighting
vim.api.nvim_set_keymap("n", "<CR>", " :noh<Cr>", {noremap = true})
