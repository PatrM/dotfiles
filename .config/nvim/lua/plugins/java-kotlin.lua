local function gradle_root(path)
  local settings = vim.fs.find({ "settings.gradle.kts", "settings.gradle" }, {
    path = path,
    upward = true,
  })[1]
  if settings then
    return vim.fs.dirname(settings)
  end

  local fallback = vim.fs.find({ "gradlew", ".git", "pom.xml", "build.xml", "build.gradle.kts", "build.gradle" }, {
    path = path,
    upward = true,
  })[1]
  return fallback and vim.fs.dirname(fallback) or nil
end

return {
  {
    "mfussenegger/nvim-jdtls",
    optional = true,
    opts = function(_, opts)
      opts.root_dir = function(path)
        return gradle_root(path)
      end

      opts.project_name = function(root_dir)
        if not root_dir then
          return nil
        end
        local name = vim.fs.basename(root_dir)
        local hash = vim.fn.sha256(root_dir):sub(1, 8)
        return string.format("%s-%s", name, hash)
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.kotlin_language_server = vim.tbl_deep_extend("force", opts.servers.kotlin_language_server or {}, {
        root_dir = function(fname)
          return gradle_root(fname)
        end,
      })
    end,
  },
}
