vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wildmode = {'full'}
vim.wo.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.foldmethod = "syntax"
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"
vim.opt.foldlevel = 99

--#region color schemes ----
-- gruvbox settings
vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_italicize_comments = 1
vim.g.gruvbox_italicize_strings = 1

-- tokyonight settings
vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_transparent_sidebar = true

-- catppuccin settings
vim.g.catppuccin_flavour = "macchiato"
require("catppuccin").setup()




--#region the actual colorscheme
vim.cmd "colorscheme rose-pine"
--#endregion
--#endregion color schemes ----

--#region generic colorscheme adaptions
vim.cmd "highlight Normal guibg=NONE"
vim.cmd "highlight VertSplit guifg=cyan"
--#endregion
