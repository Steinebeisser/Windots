return {
	"nvim-lualine/lualine.nvim",
	requires = { "nvim-tree/nvim-web-devicons" },
	config = function()
        local mode = {
            "mode",
            fmt = function (str)
                return '⚔️' .. str
            end,
        }
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "codedark",
                section_separators = { left = '', right = '' },
                component_separators = "|",
                disabled_filetypes = { 'alpha', 'neo-tree' },
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "branch", "diff" },
				lualine_c = { "filename" },
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
						colored = true,
						always_visible = true,
					},
				},
				lualine_y = {
					"progress",
					function()
						return " " .. os.date("%H:%M") -- Adds a clock icon () next to the current time
					end,
				},
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = {},
		})
	end,
}
