vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    -- ['<C-p>'] = cmp.mapping.select_prev_item(), need to find another hotkey here?
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  sources = {
    { name = 'gh_issues' },
    { name = 'nvim_lsp', keyword_length = 1 },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'buffer', keyword_length = 4 },
  },
  experimental = {
    native_menu = false,
    ghost_text = true
  },
}

cmp.setup.cmdline('/', {
  view = {
    entries = {name = 'wildmenu', separator = '|' }
  },
})
