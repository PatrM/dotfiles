local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.nvim_workspace()

-- Lua LSP
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)



-- General setup
lsp.setup()



-- local local_config = require('local-config')
-- local opts = {
--   noremap = true,
--   silent = true
-- }
-- -- diagnosic keymaps
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- -- Diagnostic config
-- vim.diagnostic.config({
--   virtual_text = true,
--   signs = true,
--   underline = true,
--   update_in_insert = false,
--   severity_sort = false,
-- })


-- -- Use an on_attach function to only map the following keys after the language server attaches to the current buffer

-- local on_attach = function(client, bufnr)

--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--   vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--   vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--   vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
--   vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
--   vim.keymap.set('n', '<space>wl', '<cmd>print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
--   vim.keymap.set('n', '<space>rr', vim.lsp.buf.rename, opts)
--   vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
--   vim.keymap.set('n', '<space>ll', vim.lsp.buf.format, opts)
-- end

-- -- Use a loop to conveniently call 'setup' on multiple servers and
-- -- map buffer local keybindings when the language server attaches
-- local servers = { 'pyright', 'tsserver', 'dockerls', 'cssls', 'tailwindcss', 'ansiblels', 'gopls', 'gradle_ls', 'jsonls', 'rust_analyzer' }
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- config = {
--     capabilities = capabilities,
--     on_attach = on_attach,
--     flags = {
--       -- This will be the default in neovim 0.7+
--       debounce_text_changes = 150,
--     }
-- }

-- for _, lsp in pairs(servers) do
--   require('lspconfig')[lsp].setup(config)
-- end

-- -- Typescript LSP
-- require'lspconfig'.tsserver.setup {
--     capabilities = capabilities,
--     on_attach = on_attach,
--     flags = {
--       -- This will be the default in neovim 0.7+
--       debounce_text_changes = 150,
--     },
--     file_types = { "javascript", "javascriptreact", "javascript.jsx", "typescript", 'html', "typescriptreact", "typescript.tsx" },
-- }

-- -- Angular LSP. the --viewEngine parameter is only needed when working with pre-Ivy projects
-- local global_node_modules = local_config.lsp.global_node_modules
-- local cmd = {"ngserver", "--stdio", "--tsProbeLocations", global_node_modules , "--ngProbeLocations", global_node_modules, "--viewEngine"}
-- require'lspconfig'.angularls.setup {
--     capabilities = capabilities,
--     on_attach = on_attach,
--     flags = {
--       -- This will be the default in neovim 0.7+
--       debounce_text_changes = 150,
--     },
--     cmd = cmd,
--     on_new_config = function(new_config, new_root_dir)
--       new_config.cmd = cmd
--     end,
-- }

-- -- YAML (with kubernetes scheme)
-- require('lspconfig').yamlls.setup{
--     settings = { yaml = { schemas = { kubernetes =  'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.1-standalone/all.json'}}}
-- }

-- -- Rust LSP
-- require'lspconfig'.rust_analyzer.setup{}

-- -- Lua LSP
-- local runtime_path = vim.split(package.path, ';')
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
-- require'lspconfig'.sumneko_lua.setup {
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT',
--         -- Setup your lua path
--         path = runtime_path,
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = {'vim'},
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = vim.api.nvim_get_runtime_file("", true),
--         checkThirdParty = false,
--       },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- }

-- vim.cmd [[
-- augroup jdtls_lsp
--   autocmd!
--   autocmd FileType java lua require('jdtls-config').setup(config)
-- augroup end
-- ]]
