return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- Automatically update parsers on update
    config = function()
        require('nvim-treesitter.configs').setup {
            --auto_install = true,
            vim.treesitter.language.register("c_sharp", "csharp"),
            ensure_installed = { "c_sharp" },
            highlight = { enable = true }, -- Enable syntax highlighting using Tree-sitter
            indent = { enable = true },    -- Enable indentation based on Tree-sitter
            -- You can add other Tree-sitter modules here as needed
            additional_vim_regex_highlighting = { "c_sharp" },
        }
    end
}
