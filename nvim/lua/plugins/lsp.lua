local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.g.disable_autoformat = false

local function keymap(mode, l, r, opts)
	opts = opts or {}
	opts.buffer = true
	opts.desc = string.format("Lsp: %s", opts.desc)
	vim.keymap.set(mode, l, r, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),
	callback = function(args)
		keymap("n", "gh", function()
			vim.lsp.buf.hover()
		end, { desc = "Hover" })

		keymap("n", "<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, { desc = "Toggle inlay hints" })

		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
					-- vim.lsp.buf.formatting_sync()
					if not vim.g.disable_autoformat then
						vim.lsp.buf.format({ async = false })
					end
				end,
			})
		end
	end,
})

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
		version = "*", -- or a specific tag like "v0.1.6"
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
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
