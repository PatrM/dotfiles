-- clone packer if it doesn't exist yetinit
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

-- disabling netrw as early as possible for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'MDeiml/tree-sitter-markdown'
    use 'nvim-lua/plenary.nvim'
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use 'p00f/nvim-ts-rainbow'
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    -- Copilot
    -- use 'github/copilot.vim'

    -- Telescope
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use {
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-telescope/telescope-live-grep-args.nvim" }
        }
    }

    -- Aerial - Code Outline
    use({
        "stevearc/aerial.nvim",
        -- config = function()
        -- require("aerial").setup()
        -- end,
    })

    -- Styling
    use 'morhetz/gruvbox'
    use({ "catppuccin/nvim", as = "catppuccin" })
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            require("rose-pine").setup()
        end
    })
    use 'folke/tokyonight.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icon
        },
        config = function()
            require 'nvim-tree'.setup({
                filters = {
                    dotfiles = false,
                },
                renderer = {
                    group_empty = true
                }
            })
        end
    }
    -- Dashboard
    use 'mhinz/vim-startify'

    -- Git related
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'
    use 'tpope/vim-rhubarb'
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

    -- LSP & CMP
    use 'neovim/nvim-lspconfig'
    use 'mfussenegger/nvim-jdtls'
    use 'mfussenegger/nvim-dap-python'
    use 'hrsh7th/nvim-cmp'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            { 'williamboman/mason.nvim' }, -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'hrsh7th/cmp-buffer' }, -- Optional
            { 'hrsh7th/cmp-path' }, -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' }, -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' }, -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        }
    }
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    -- use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

    use 'jayp0521/mason-nvim-dap.nvim'
    -- use {
    --   'hrsh7th/nvim-cmp',
    --   config = function ()
    --     require'cmp'.setup {
    --     snippet = {
    --       expand = function(args)
    --         require'luasnip'.lsp_expand(args.body)
    --       end
    --     },

    --     sources = {
    --       { name = 'luasnip' },
    --       -- more sources
    --     },
    --   }
    --   end
    -- }
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

    -- SQL
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'
end)


--------------------------- leader definition
vim.g.mapleader = ' '

-- https://www.notonlycode.org/neovim-lua-config/
require('options-config')
require('treesitter-config')
require('nvim-cmp-config')
require('signature-config')
require('telescope-config')
-- require('dap-config')
require('mason-config')
require('lsp-config')
require('custom-statusline')
require('custom-note-taking')
-- require('lua-snip-config')

-- Aerial
local aerial = require('aerial')
aerial.setup({
    close_automatic_events = { "unsupported" },
    open_automatic = function(bufnr)
        -- Enforce a minimum line count
        return vim.api.nvim_buf_line_count(bufnr) > 40
            -- Enforce a minimum symbol count
            and aerial.num_symbols(bufnr) > 4
            -- A useful way to keep aerial closed when closed manually
            and not aerial.was_closed()
    end,
    lazy_load = false,
})

--------------------------- nvim-tree
require 'nvim-tree'.setup {
    auto_reload_on_write = true,
    view = {
        width = 30,
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
}
vim.g.nvim_tree_git_highlights = 1
vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', { noremap = true })
vim.keymap.set('n', '<leader>to', '<cmd>NvimTreeFindFile<cr>', { noremap = true })
vim.keymap.set('n', '<leader>tr', '<cmd>NvimTreeRefresh<cr>', { noremap = true })
vim.keymap.set('n', '<leader>ta', '<cmd>AerialToggle<cr>', { noremap = true })

--------------------------- Dashboard
vim.g.startify_change_to_vcs_root = 1
--------------------------- icons
require 'nvim-web-devicons'.setup {
    default = true,
}

--------------------------- gitsigns
require('gitsigns').setup()


--------------------------- markdown-preview
vim.cmd([[
let g:mkdp_preview_options = {'maid': { 'theme' : 'dark' }}
]])


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
vim.keymap.set('n', '<CR>', ' :noh<Cr>', { noremap = true }) -- cancel search highlight with enter
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = 0, noremap = true })
vim.keymap.set('n', '<leader>dd', '"_dd', { noremap = true })
vim.keymap.set('v', '<leader>dv', '"_d', { noremap = true })
vim.keymap.set('n', '<leader>tf', '<cmd>SymbolsOutline<cr>', { noremap = true })

-- moving lines by alt + j/k
vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { noremap = true })
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { noremap = true })
vim.keymap.set('i', '<C-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })
vim.keymap.set('i', '<C-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { noremap = true })

-- Enclosing current word with quote
vim.keymap.set('n', "<Leader>q'", "ciw''<Esc>P", { noremap = true })
vim.keymap.set('n', '<Leader>q"', 'ciw""<Esc>P', { noremap = true })
vim.keymap.set('n', '<Leader>q`', 'ciw``<Esc>P', { noremap = true })


--------------------------- buffer movement
vim.keymap.set('n', '<leader>b.', '<cmd>bnext<cr>', { noremap = true })
vim.keymap.set('n', '<leader>b,', '<cmd>bprevious<cr>', { noremap = true })
