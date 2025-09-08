vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = '80'
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = false
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.wrap = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.winborder = 'rounded'
vim.opt.swapfile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '→ ', trail = '·' }
vim.opt.title = true
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false

vim.opt.completeopt = 'menuone,noinsert'
vim.opt.pumheight = 15

vim.opt.laststatus = 3

vim.cmd('syntax on')
vim.cmd('colorscheme habamax')
vim.cmd('filetype plugin indent on')


-- plugins
vim.pack.add({
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/echasnovski/mini.pick' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/seblyng/roslyn.nvim' },
    { src = 'https://github.com/nvim-mini/mini.tabline' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
})

require 'mini.tabline'.setup()
require 'oil'.setup()
require 'mini.pick'.setup()
require('mason').setup({
    registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
    },
})
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'clangd',
    },
    automatic_enable = {}
})

require("luasnip").setup({ enable_autosnippets = true })

local nvim_dir = vim.fn.stdpath('config')
local snippets_dir = nvim_dir .. '/snippets/'
require("luasnip.loaders.from_lua").load({
    paths = { snippets_dir },
})
local ls = require("luasnip")
vim.keymap.set("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

vim.lsp.enable({
    'lua_ls',
    'clangd',
})


vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
            telemetry = { enable = false },
        }
    }
})


function _G.statusline()
    local branch = vim.b.gitsigns_head or ''
    if branch ~= '' then
        branch = '  ' .. branch .. ' '
    end

    return table.concat({
        '%f',
        branch,
        '%m%r',
        '%=',
        '%l:%c',
        ' (%p%%, %Ll)',
    }, ' ')
end

vim.opt.statusline = '%!v:lua.statusline()'

vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>fh', ':Pick help<CR>')
vim.keymap.set('n', '<leader>bb', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<leader>bp', ':bprev<CR>')
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')
vim.keymap.set('n', '<leader>=', '<C-w>=')
vim.keymap.set('n', '<leader>c', ':close<CR>')
vim.keymap.set('n', '<leader>v', ':vsplit<CR>')
vim.keymap.set('n', '<leader>h', ':split<CR>')
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- auto cmds
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    callback = function()
        vim.opt.cursorline = true
    end
})

vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
    callback = function()
        vim.opt.cursorline = false
    end
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local opts = { buffer = args.buf }
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)

        vim.keymap.set('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
        end, opts)

        if client and client.name == 'roslyn' and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end

        -- if client and client.name == 'roslyn' then
        -- vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })

        vim.api.nvim_create_autocmd('TextChangedI', {
            buffer = args.buf,
            callback = function()
                local line = vim.api.nvim_get_current_line()
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local last_char = line:sub(col, col)
                if last_char:match('[%w_]') and vim.fn.pumvisible() == 0 then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-X><C-O>', true, false, true), 'n', true)
                end
            end,
        }) -- end


        if client and client:supports_method('textDocument/formatting') then
            local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = augroup,
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'cs',
    callback = function()
        if vim.fn.executable('dotnet') == 0 then
            vim.notify('Roslyn LSP unavailable (install .NET SDK)', vim.log.levels.WARN)
            return
        end

        -- require('roslyn').setup()


        vim.lsp.config('roslyn', {
            root_dir = function()
                return vim.fs.dirname(vim.fs.find({ '.csproj', 'Directory.Build.props', '.sln' }, { upward = true })[1])
            end,
        })
    end
})

vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    callback = function(event)
        local nvim_dir = vim.fn.stdpath('config')
        local ft = vim.bo[event.buf].filetype
        local make_file = nvim_dir .. '/make/' .. ft .. '.lua'
        if vim.fn.filereadable(make_file) == 1 then
            dofile(make_file)
        end
    end,
})

if vim.loop.os_uname().sysname == 'Windows_NT' then
    if vim.fn.executable('pwsh') == 1 then
        vim.opt.shell = 'pwsh'
    elseif vim.fn.executable('powershell') == 1 then
        vim.opt.shell = 'powershell'
    end
    vim.opt.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command'
    vim.opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.opt.shellquote = ''
    vim.opt.shellxquote = ''
else
    vim.opt.shell = '/bin/zsh'
end
