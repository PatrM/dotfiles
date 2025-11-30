return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.configurations.go = {
        {
          type = "go",
          name = "Run file",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          mode = "debug",
        },
      }
    end,
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require('dap-go').setup({
        delve = {
          path = "/Users/patrick/go/bin/dlv"
        }
      })
    end,
  },
  { import = "lazyvim.plugins.extras.dap.core" },
}