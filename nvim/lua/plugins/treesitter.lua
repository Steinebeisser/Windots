return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- Automatically update parsers on update
    config = function()
        require('nvim-treesitter.configs').setup {
            --auto_install = true,
            vim.treesitter.language.register("c_sharp", "csharp"),
            ensure_installed = { "c_sharp" },
            auto_install = true,
            highlight = {
                  enable = true,
                  -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                  --  If you are experiencing weird indenting issues, add the language to
                  --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                  additional_vim_regex_highlighting = { 'ruby' },
            },
        }
    end
}
