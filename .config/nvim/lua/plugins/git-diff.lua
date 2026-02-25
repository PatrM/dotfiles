local function git(args)
  local out = vim.fn.system(vim.list_extend({ "git" }, args))
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

local function detect_default_branch()
  local origin_head = git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
  if origin_head and origin_head ~= "" then
    local branch = origin_head:match("^origin/(.+)$")
    if branch and branch ~= "" then
      return branch
    end
  end

  for _, branch in ipairs({ "master", "main" }) do
    if git({ "rev-parse", "--verify", branch }) then
      return branch
    end
  end

  return "HEAD"
end

local function open_diff(opts)
  local base = detect_default_branch()
  local path = opts.path and vim.trim(opts.path) or "."
  if path == "" then
    path = "."
  end

  local range = opts.local_state and (base .. "...HEAD --imply-local") or (base .. "..HEAD")
  vim.cmd("DiffviewOpen " .. range .. " -- " .. vim.fn.fnameescape(path))
end

local function prompt_and_open(local_state)
  vim.ui.input({
    prompt = "Compare path (default: .): ",
    default = ".",
    completion = "dir",
  }, function(input)
    if input == nil then
      return
    end
    open_diff({ local_state = local_state, path = input })
  end)
end

return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gdm",
        function()
          prompt_and_open(false)
        end,
        desc = "Diff vs default branch",
      },
      {
        "<leader>gdc",
        function()
          prompt_and_open(true)
        end,
        desc = "Diff local vs default branch",
      },
      {
        "<leader>gdx",
        "<cmd>DiffviewClose<cr>",
        desc = "Close diffview",
      },
    },
    config = function()
      vim.api.nvim_create_user_command("GitDiffBase", function(opts)
        open_diff({ local_state = false, path = opts.args })
      end, {
        nargs = "?",
        complete = "dir",
        desc = "Compare path against default branch",
      })

      vim.api.nvim_create_user_command("GitDiffBaseLocal", function(opts)
        open_diff({ local_state = true, path = opts.args })
      end, {
        nargs = "?",
        complete = "dir",
        desc = "Compare local path state against default branch",
      })
    end,
  },
}
