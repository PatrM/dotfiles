local M = {}
function M.setup(config)
  local local_config = require('local-config')

  vim.cmd [[
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
    command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
    command! -buffer JdtJol lua require('jdtls').jol()
    command! -buffer JdtBytecode lua require('jdtls').javap()
    command! -buffer JdtJshell lua require('jdtls').jshell()
    command! -buffer JdtTestMethod lua require('jdtls').test_nearest_method()
    command! -buffer JdtTestClass lua require('jdtls').test_class()
  ]]

  -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
  local jdtls_config = {}

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  jdtls_config.capabilities =  capabilities

  jdtls_config.on_attach = function (client, bufnr)
    require('jdtls.setup').add_commands()
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.dap').setup_dap_main_class_configs()
    config.on_attach(client, bufnr)
  end

  jdtls_config.cmd = {
    local_config.jdtls.java_command,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. '/Users/patrick/dev/tools/lombok.jar',
    '-Xms1g', -- can be increased if more is needed
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', vim.fn.glob(local_config.jdtls.jdtls_dir_launcher),
    '-configuration', local_config.jdtls.jdtls_system_config,
    '-data', local_config.jdtls.work_dir
  }
  jdtls_config.root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})

  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  jdtls_config.settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = local_config.jdtls.runtimes,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
          settings = {
            -- see https://github.com/mfussenegger/nvim-jdtls/issues/203 for some discussions
            --  profile = "asdf",
            --  url = 'as/df,
        }
      },
      project = {
        referencedLibraries = local_config.jdtls.referenced_libraries
      }
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
    },
  }

  local bundles = {
    vim.fn.glob(local_config.jdtls.java_debug_dir),
  }
  vim.notify(local_config.jdtls.vscode_java_test_dir, vim.log.levels.INFO)
  vim.list_extend(bundles, vim.split(vim.fn.glob(local_config.jdtls.vscode_java_test_dir), "\n"))


  local default_capabilities = require('jdtls').extendedClientCapabilities
  default_capabilities.resolveAdditionalTextEditsSupport = true

  jdtls_config.init_options = {
    bundles = bundles,
    extendedClientCapabilities = default_capabilities,
  }

  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  require('jdtls').start_or_attach(jdtls_config)
end

return M
