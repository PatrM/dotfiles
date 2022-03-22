require('telescope').setup {
  -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  defaults = {
    path_display = {'tail'},
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", '┌', '┐', '┘', '└' },
    color_devicons = true,
    file_ignore_patterns = { "node_modules" },
    layout_strategy = "horizontal",
    layout_config = {
       horizontal = {
          prompt_position = "bottom",
          preview_width = 0.55,
          results_width = 0.8,
       },
       vertical = {
          mirror = false,
       },
       width = 0.4,
       height = 0.8,
       preview_cutoff = 120,
    },
  },
  pickers = {
    find_files = {

    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = 'smart_case',        -- or 'ignore_case' or 'respect_case'
                                       -- the default case_mode is 'smart_case'
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')


-- TEMPORARY function to use find_files as fallback, should be in separate file (telescope_config.lua)
project_files = function()
  local opts = {
    previewer = false
  } -- define here if you want to define something
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

-- Telescope keymaps
vim.keymap.set('n', '<C-p>', project_files, {silent = true, noremap = true})
vim.keymap.set('n', '<leader>fw', require'telescope.builtin'.grep_string, {silent = true, noremap = true})
vim.keymap.set('n', '<leader>fa', require'telescope.builtin'.live_grep, {silent = true, noremap = true})
