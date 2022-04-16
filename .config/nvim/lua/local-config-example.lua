local M = {}
-- home dir of system. could be read from OS as well
local home_dir = os.getenv('HOME')

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- eclipse workspace directory
local work_dir = home_dir .. '/dev/workspaces/' .. project_name
local jdtls_dir = home_dir .. '/dev/tools/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'

-- launcher jar for jdt language server
local jdtls_dir_launcher = jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_*.jar'

-- needs to be modified if not on mac
local jdtl_system_config = jdtls_dir .. '/config_mac'

-- needed for java debugging
local java_debug_dir = home_dir .. '/dev/tools/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
local vscode_java_test_dir = home_dir .. '/dev/tools/vscode-java-test/server/*.jar'

M.jdtls = {
  work_dir = work_dir,
  jdtls_dir = jdtls_dir,
  jdtls_dir_launcher = jdtls_dir_launcher,
  jdtls_system_config = jdtl_system_config,
  java_debug_dir = java_debug_dir,
  vscode_java_test_dir = vscode_java_test_dir,
  referenced_libraries = {
    -- strings to references libs (like e.g. Lombok) can be added here
  },
  java_command = "java", -- or direct java path if java isn't in $PATH
}

M.dbui = {
  dbs = {
    local_with_password = 'postgres://postgres:mypassword@localhost:5432/postgres',
    local_without_password = 'postgres://postgres@localhost:5432/postgres', -- this will popup with a password prompt when starting connection
  },
  helpers = {
    postgres = {
      count = 'select count(*) from "{table}"'
    },
  },
}

return M
