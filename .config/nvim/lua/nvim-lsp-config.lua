vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, {buffer=0})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {buffer=0})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {buffer=0})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {buffer=0})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0})
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {buffer=0})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=0})
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {buffer=0})
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, {buffer=0})
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, {buffer=0})
  vim.keymap.set('n', '<space>wl', '<cmd>print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', {buffer=0})
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, {buffer=0})
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, {buffer=0})
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, {buffer=0})
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, {buffer=0})
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, {buffer=0})

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'angularls', 'tsserver', 'dockerls' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end
