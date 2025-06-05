vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.cs",
	callback = function()
		vim.bo.filetype = "c_sharp"
	end,
})
