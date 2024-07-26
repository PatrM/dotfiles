local M = {}
-- home dir of system. could be read from OS as well
local home_dir = os.getenv('HOME')

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- eclipse workspace directory
local work_dir = home_dir .. '/dev/workspaces/' .. project_name
local jdtls_dir = home_dir .. '/dev/tools/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'


M.jdtls = {
  work_dir = work_dir,
  jdtls_dir = jdtls_dir,
  referenced_libraries = {
    -- strings to references libs (like e.g. Lombok) can be added here
  },
  runtimes = {
      {
          name = 'JavaSE-1.8',
          path = ''
      },
      {
        name = "JavaSE-11",
        path = "/Users/patrick/.sdkman/candidates/java/11.0.15.9.1-amzn/",
      },
      {
        name = "JavaSE-17",
        path = "/usr/lib/jvm/java-17-openjdk/",
      },
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

M.notes = {
  journal_path = '~/dev/notes/journal/'
}

M.lsp = {
  global_node_modules = '/Users/patrick/.nvm/versions/node/v16.14.2/lib'
}
return M
