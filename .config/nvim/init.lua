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
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'

  -- Status
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true }}

  -- Styling
  use 'morhetz/gruvbox'
  use 'kyazdani42/nvim-web-devicons'

  -- Git related
  use 'tveskag/nvim-blame-line'
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'

  -- LSP & CMP
  use 'neovim/nvim-lspconfig'
  use 'mfussenegger/nvim-jdtls'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lua'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'

end)


vim.g.mapleader = ' '
-- https://www.notonlycode.org/neovim-lua-config/
require('options-config')
require('treesitter-config')
require('nvim-lsp-config')
require('nvim-cmp-config')
require('telescope-config')

-- Status line
require('lualine').setup();
--------------------------- icons
require'nvim-web-devicons'.setup {
 default = true;
}
--------------------------- icons END

vim.keymap.set("n", "<CR>", " :noh<Cr>", {noremap = true}) -- cancel search highlight with enter
vim.keymap.set("n", "<leader>fg", "<cmd> lua require('telescope.builtin').livegrep()<cr>", {noremap = true})
vim.keymap.set("n", "<leader>fb", "<cmd> lua require('telescope.builtin').buffers()<cr>", {noremap = true})
vim.keymap.set("n", "<leader>fh", "<cmd> lua require('telescope.builtin').help_tags()<cr>", {noremap = true})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer = 0, noremap = true})

