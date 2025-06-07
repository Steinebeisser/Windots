return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				auto_install = true,
			})
		end,
	},

	{
		"neovim/nvim-lspconfig", -- Specify a minimum version to avoid compatibility issues
		version = "*",     -- or a specific tag like "v0.1.6"
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
			})
			--lspconfig.roslyn.setup({
			--capabilities = capabilities
			--})
			--vim.lsp.config("roslyn", {
			--capabilities = capabilities
			--})
			--vim.lsp.enable("roslyn")
		end,
	},
}
