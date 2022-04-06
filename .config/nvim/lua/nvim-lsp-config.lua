
local opts = {
  noremap = true,
  silent = true
}
-- diagnosic keymaps
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)



-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<space>wl', '<cmd>print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rr', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'angularls', 'tsserver', 'dockerls', 'sumneko_lua' }
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
config = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
}

for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup(config)
end

vim.cmd [[
augroup jdtls_lsp
  autocmd!
  autocmd FileType java lua require('jdtls-config').setup(config)
augroup end
]]
