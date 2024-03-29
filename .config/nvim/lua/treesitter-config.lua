require 'nvim-treesitter.configs'.setup {
    ensure_installed = { 'java', 'javascript', 'typescript', 'markdown_inline', 'html', 'css', 'python',
        'kotlin', 'lua', 'c_sharp', 'go', 'latex', 'json', 'javascript', 'jsdoc', 'tsx', 'vue', 'yaml', 'dockerfile', 'graphql', 'rust', 'svelte' },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    highlight = {
        -- `false` will disable the whole extension
        enable = true,
        -- disable = { 'html' }, -- disabled until https://github.com/neovim/neovim/pull/18109 is merged
        -- list of language that will be disabled
        --
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    }
}

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.markdown = {
    install_info = {
        url = "https://github.com/ikatyang/tree-sitter-markdown",
        files = { "src/parser.c", "src/scanner.cc" },
    },
    filetype = "markdown",
}
