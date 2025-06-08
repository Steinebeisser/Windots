if vim.loop.os_uname().sysname == "Windows_NT" then
  vim.opt.shell = "powershell.exe"
end

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', {silent = true })

local opts = { noremap = true, silent = true }

-- save
vim.keymap.set({'n', 'i'}, '<C-s>', '<cmd> w <CR>', {})

-- no delete into buffer
vim.keymap.set('n', 'x', '"_x', opts)

vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- windows
vim.keymap.set('n', '<leader>v', '<C-w>v', opts)
vim.keymap.set('n', '<leader>h', '<C-w>s', opts)
vim.keymap.set('n', '<leader>se', '<C-w>=v', opts)
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts)

vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

--terminal
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts) --go to normal mode with esc
vim.keymap.set('n', '<leader>nt', ':vsplit | term<CR>i', opts)

-- splitnav
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

--buffer
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>nb', '<cmd> enew <CR>', opts) -- new buffer

-- tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts)
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts)
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts)


-- line wrap
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- dont yank what deleted when pasting
vim.keymap.set('v', 'p', '"_dp', opts)

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- TELESCOPE
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, opts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)
vim.keymap.set('n', '<leader>fe', function()
    require("telescope").extensions.file_browser.file_browser()
end, opts)



-- LSP
vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
vim.keymap.set('n', 'gI', builtin.lsp_implementations, opts)
vim.keymap.set('n', '<leader>D', builtin.lsp_type_definitions, opts)
vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, opts)
vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols, opts)

-- Built-in LSP functions
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
-- LUASNIP
local ls = require("luasnip")

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})


-- funny 
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton game_of_life<CR>")
