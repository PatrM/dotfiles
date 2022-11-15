local previewers = require("telescope.previewers")
require('telescope').setup {
  -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  defaults = {
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    winblend = 0,
    path_display = {'smart'},
    border = {},
    borderchars = { "─", "│", "─", "│", '┌', '┐', '┘', '└' },
    color_devicons = true,
    file_ignore_patterns = { "node_modules" },
    layout_strategy = "vertical",
    layout_config = {
       horizontal = {
          prompt_position = "bottom",
          preview_width = 0.7,
          results_width = 0.3,
       },
       vertical = {
          mirror = false,
       },
    },
  },
  pickers = {
    find_files = {

    },
    live_grep = {
--      additional_args = function (opts)
--        return {'--hidden', '--glob "!.git/"'}
--      end
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = 'smart_case',        -- or 'ignore_case' or 'respect_case'
                                       -- the default case_mode is 'smart_case'
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
require("telescope").load_extension("ui-select")
require("telescope").load_extension("live_grep_args")

local project_files = function()
  local opts = {
    -- previewer = false,
    --   path_display = {'smart'},
  }
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

-- Telescope keymaps
vim.keymap.set('n', '<leader>ff', project_files, {silent = true, noremap = true})
--vim.keymap.set('n', '<leader><Shift>F', all_project_files, {silent = true, noremap = true})
vim.keymap.set('n', '<leader>bb', require'telescope.builtin'.buffers, {silent = true, noremap = true})
vim.keymap.set('n', 'gr', require'telescope.builtin'.lsp_references, {silent = true, noremap = true})
vim.keymap.set('n', '<leader>fw', require'telescope.builtin'.grep_string, {silent = true, noremap = true})
vim.keymap.set('n', '<leader>fa', require'telescope.builtin'.live_grep, {silent = true, noremap = true})
vim.keymap.set('n', '<leader>fA', require("telescope").extensions.live_grep_args.live_grep_args, {silent = true, noremap = true})
vim.keymap.set("n", "<leader>fh", require'telescope.builtin'.help_tags, {noremap = true})
vim.keymap.set("n", "<leader>fg", require'telescope.builtin'.git_status, {noremap = true})
