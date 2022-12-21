require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright', 'tsserver', 'dockerls', 'cssls',
        'tailwindcss', 'ansiblels', 'gopls', 'gradle_ls',
        'jsonls', 'rust_analyzer', 'sumneko_lua',
        'angularls', 'jdtls', 'yamlls', 'marksman', 'pyright', 'gradle_ls'
    },
    automatic_installation = true
})
require('nvim-lsp-config')
