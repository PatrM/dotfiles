local M = {}
function M.setup(config)
  
  assert(config, 'config is required')
  assert(config.on_attach, 'on_attach must be set')

  --- ========= BELOW NEEDS TO BE MODIFIED ===========
  -- eclipse workspace directory
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workdir = '/Users/patrick/dev/workspaces/' .. project_name

  -- rootdir of jdtls
  local jdtls_dir = '/Users/patrick/dev/tools/jdtls/jdt-language-server-1.9.0-202203031534'

  -- launcher jar for jdt language server 
  local jdtls_dir_launcher = jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'

  -- needs to be modified if not on mac
  local jdtls_system_config = jdtls_dir .. '/config_mac'

  -- can be replaced with direct path to java if 'java' isn't in $PATH
  local java_command = 'java'
  
  -- ========= END MODIFICATION

  vim.cmd [[
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
    command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
    command! -buffer JdtJol lua require('jdtls').jol()
    command! -buffer JdtBytecode lua require('jdtls').javap()
    command! -buffer JdtJshell lua require('jdtls').jshell()
  ]]

  -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
  local jdtls_config = {}
  
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  jdtls_config.capabilities =  capabilities

  jdtls_config.on_attach = function (client, bufnr)
    require('jdtls.setup').add_commands()
    config.on_attach(client, bufnr)

  end

  jdtls_config.cmd = {
    java_command,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g', -- can be increased if more is needed
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', jdtls_dir_launcher,
    '-configuration', jdtls_system_config,
    '-data', workdir
  }
  jdtls_config.root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})

  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  jdtls_config.settings = {
    java = {
    }
  }
  jdtls_config.init_options = {
    bundles = {}
  },

  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  require('jdtls').start_or_attach(jdtls_config)
end

return M
