-- Neorg parser setup
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
-- These two are optional and provide syntax highlighting
-- for Neorg tables and the @document.meta tag
parser_configs.norg_meta = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main"
    },
}

parser_configs.norg_table = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main"
    },
}


require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {'norg', 'java', 'javascript', 'typescript', 'markdown', 'html', 'css', 'python', 'kotlin', 'lua', 'c_sharp', 'go', 'latex', 'json', 'jsdoc', 'tsx', 'vue', 'yaml', 'dockerfile', 'graphql'},

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,


  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    --
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
