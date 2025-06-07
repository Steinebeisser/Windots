return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
		})
		vim.cmd.colorscheme("catppuccin")

		local colors = require("catppuccin.palettes").get_palette()

		require("notify").setup({
			background_colour = colors.base, -- or colors.mantle/overlay0 etc.
		})

		local bg_transparent = true
		local toggle_transparency = function()
			bg_transparent = not bg_transparent

			require("catppuccin").setup({
				transparent_background = bg_transparent,
			})
			vim.cmd.colorscheme("catppuccin")
		end

		vim.keymap.set("n", "<leader>bg", toggle_transparency, { noremap = true, silent = true })
	end,
}
