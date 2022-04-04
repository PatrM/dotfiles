local M = {}
-- home dir of system. could be read from OS as well
local home_dir = '/Users/patrick/'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- eclipse workspace directory
local work_dir = home_dir .. 'dev/workspaces/' .. project_name
local jdtls_dir = home_dir .. 'dev/tools/jdtls/jdt-language-server-1.9.0-202203031534'
-- launcher jar for jdt language server
local jdtls_dir_launcher = jdtls_dir .. '/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar'
-- needs to be modified if not on mac
local jdtl_system_config = jdtls_dir .. '/config_mac'
M.jdtls = {
  work_dir = work_dir,
  jdtls_dir = jdtls_dir,
  jdtls_dir_launcher = jdtls_dir_launcher,
  jdtls_system_config = jdtl_system_config,
  java_command = "java", -- or direct java path if java isn't in $PATH
}

return M
