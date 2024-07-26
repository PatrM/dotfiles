require('mason').setup()
vim.filetype.add({ extension = { templ = "templ" } })
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright', 'tsserver', 'dockerls', 'cssls',
        'tailwindcss', 'ansiblels', 'gopls', 'templ', 'gradle_ls',
        'jsonls', 'rust_analyzer', 'lua_ls',
        'angularls', 
        -- 'jdtls', 
        'yamlls', 'marksman', 'pyright', 'gradle_ls'
    },
    automatic_installation = true,
    -- jdtls = function()
        -- -- use this function notation to build some variables
        -- local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
        -- local root_dir = require("jdtls.setup").find_root(root_markers)
        -- local local_config = require('local_config')

        -- -- calculate workspace dir
        -- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        -- os.execute("mkdir " .. local_config.jdtls.work_dir)

        -- -- get the mason install path
        -- local install_path = require("mason-registry").get_package("jdtls"):get_install_path()

        -- -- get the current OS
        -- local os
        -- if vim.fn.has "macunix" then
        --     os = "mac"
        -- elseif vim.fn.has "win32" then
        --     os = "win"
        -- else
        --     os = "linux"
        -- end  
        -- local default_capabilities = require('jdtls').extendedClientCapabilities
        -- default_capabilities.resolveAdditionalTextEditsSupport = true

        -- -- return the server config
        -- return {
        --     cmd = {
        --         local_config.jdtls.java_command,
        --         "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        --         "-Dosgi.bundles.defaultStartLevel=4",
        --         "-Declipse.product=org.eclipse.jdt.ls.core.product",
        --         "-Dlog.protocol=true",
        --         "-Dlog.level=ALL",
        --         "-javaagent:" .. install_path .. "/lombok.jar",
        --         "-Xms1g",
        --         "--add-modules=ALL-SYSTEM",
        --         "--add-opens", "java.base/java.util=ALL-UNNAMED",
        --         "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        --         "-jar",
        --         vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        --         "-configuration", install_path .. "/config_" .. os,
        --         "-data", local_config.jdtls.work_dir,
        --     },
        --     root_dir = root_dir,
        --     on_attach = function(client, bufnr)

        --     end,
        --     init_options = {
        --         extendedClientCapabilities = default_capabilities,
        --     },
        --     settings = {
        --         java = {
        --             eclipse = {
        --                 downloadSources = true,
        --             },
        --             configuration = {
        --                 updateBuildConfiguration = "interactive",
        --                 runtimes = local_config.jdtls.runtimes,
        --             },
        --             maven = {
        --                 downloadSources = true,
        --             },
        --             implementationsCodeLens = {
        --                 enabled = true,
        --             },
        --             referencesCodeLens = {
        --                 enabled = true,
        --             },
        --             references = {
        --                 includeDecompiledSources = true,
        --             },
        --             format = {
        --                 enabled = true,
        --                 settings = {
        --                     -- see https://github.com/mfussenegger/nvim-jdtls/issues/203 for some discussions
        --                     --  profile = "asdf",
        --                     --  url = 'as/df,
        --                 }
        --             },
        --             project = {
        --                 referencedLibraries = local_config.jdtls.referenced_libraries
        --             }
        --         },
        --         signatureHelp = { enabled = true },
        --         completion = {
        --             favoriteStaticMembers = {
        --                 "org.hamcrest.MatcherAssert.assertThat",
        --                 "org.hamcrest.Matchers.*",
        --                 "org.hamcrest.CoreMatchers.*",
        --                 "org.junit.jupiter.api.Assertions.*",
        --                 "java.util.Objects.requireNonNull",
        --                 "java.util.Objects.requireNonNullElse",
        --                 "org.mockito.Mockito.*",
        --             },
        --         },
        --     },
        -- }
    -- end,
})
