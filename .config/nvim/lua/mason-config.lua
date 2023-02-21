require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright', 'tsserver', 'dockerls', 'cssls',
        'tailwindcss', 'ansiblels', 'gopls', 'gradle_ls',
        'jsonls', 'rust_analyzer', 'lua_ls',
        'angularls', 'jdtls', 'yamlls', 'marksman', 'pyright', 'gradle_ls'
    },
    automatic_installation = true
})
