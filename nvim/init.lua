require("config.icons")
require("config.lazy")
require("config.keymaps")
require("config.options")
require("config.autocmds")

vim.diagnostic.config({
	virtual_text = true, -- show errors inline
	signs = true, -- show signs in the gutter
	underline = true, -- underline the problem code
	update_in_insert = false,
	severity_sort = true,
})
