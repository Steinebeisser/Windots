return {
	"m4xshen/hardtime.nvim",
	lazy = false,
	dependencies = { "MunifTanjim/nui.nvim" },
	config = function()
		require("hardtime").setup({
			disabled_keys = {
				["<Up>"] = { "i", "v" }, -- enable arrow key in if not in insert mode for window resizing
				["<Down>"] = { "i", "v" },
				["<Left>"] = { "i", "v" },
				["<Right>"] = { "i", "v" },
			}
		})
	end
}
