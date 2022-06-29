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

vim.g.tokyonight_style = "night"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_transparent_sidebar = true

vim.cmd "colorscheme tokyonight"

vim.cmd "highlight VertSplit guifg=cyan"
