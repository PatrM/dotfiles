-- clone packer if it doesn't exist yet
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local local_config = require('local-config')

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
  use { 'nvim-treesitter/nvim-treesitter', before = 'neorg', run = ':TSUpdate'}
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use {'nvim-telescope/telescope-ui-select.nvim' }
  use 'tpope/vim-surround'

  -- Styling
  use 'morhetz/gruvbox'
  use 'kyazdani42/nvim-web-devicons'
  use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional, for file icon
      },
      config = function() require'nvim-tree'.setup {} end
  }

  -- Dashboard
  use 'mhinz/vim-startify'

  -- Git related
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

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
  use 'ray-x/lsp_signature.nvim'
  use 'microsoft/java-debug'
  use 'microsoft/vscode-java-test'
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'

  -- Symbols outline
  use 'simrat39/symbols-outline.nvim'

  -- Neorg documentation
   use {
    "nvim-neorg/neorg",
    config = function()
        require('neorg').setup {
          load = {
            ["core.defaults"] = {}
          }
        }
    end,
    requires = "nvim-lua/plenary.nvim"
  }

  -- SQL
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'

end)


--------------------------- leader definition
vim.g.mapleader = ' '

-- https://www.notonlycode.org/neovim-lua-config/
require('options-config')
require('treesitter-config')
require('nvim-lsp-config')
require('nvim-cmp-config')
require('signature-config')
require('telescope-config')
require('custom-statusline')
--------------------------- nvim-tree
require'nvim-tree'.setup{
  open_on_setup = false,
  open_on_setup_file = false,
  auto_reload_on_write = true,
  ignore_ft_on_setup = {
    "startify",
  },
  view = {
    width = 30,
  },
  open_file = {
    quit_on_open = true,
  },
}
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_highlights = 1
vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', {noremap = true})
vim.keymap.set('n', '<leader>to', '<cmd>NvimTreeFindFile<cr>', {noremap = true})
vim.keymap.set('n', '<leader>tr', '<cmd>NvimTreeRefresh<cr>', {noremap = true})

--------------------------- Dashboard
vim.g.startify_change_to_vcs_root = 1
--------------------------- icons
require'nvim-web-devicons'.setup {
 default = true;
}

--------------------------- gitsigns
require('gitsigns').setup()

--------------------------- status line

--------------------------- symbols-outline
vim.g.symbols_outline = {
  auto_close = true,
  auto_preview = false,
  width = 35,

}

--------------------------- SQL (DadBod)
vim.g.dbs = local_config.dbui.dbs
vim.g.db_ui_table_helpers = local_config.dbui.helpers

--------------------------- misc keymap definitions where i have no clue to place them instead (yet)
vim.keymap.set('n', '<CR>', ' :noh<Cr>', {noremap = true}) -- cancel search highlight with enter
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {buffer = 0, noremap = true})
vim.keymap.set('n', '<leader>dd','"_dd', {noremap = true})
vim.keymap.set('v', '<leader>dv','"_d', {noremap = true})
vim.keymap.set('n', '<leader>tf','<cmd>SymbolsOutline<cr>', {noremap = true})


--------------------------- buffer movement
vim.keymap.set('n', '<leader>b.', '<cmd>bnext<cr>', {noremap = true})
vim.keymap.set('n', '<leader>b,', '<cmd>bprevious<cr>', {noremap = true})
