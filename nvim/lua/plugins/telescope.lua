return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-file-browser.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
        config = function()
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                        '--no-ignore', -- Include files ignored by .gitignore
                        '--hidden', -- Include hidden files
                        '--glob', '!target/', -- Exclude the `target/` directory
                        '--binary', -- Ignore all binary files
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { 'rg', '--files', '--hidden', '--no-ignore', '--glob', '!target/', '--binary'},
                    },
                },
                extensions = {
                    file_browser = {
                        hidden = true,
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                            -- even more opts
                        }
                    }
                },
            })
            -- Load extensions after setup
            telescope.load_extension('file_browser')
            telescope.load_extension("ui-select")
        end,
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        -- No separate config needed here since it's configured in the main telescope setup
    },
}
