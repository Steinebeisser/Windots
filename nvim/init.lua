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
vim.opt.confirm = true

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
    { src = 'https://github.com/hrsh7th/nvim-cmp' },
    { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
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

local cmp_ok, cmp = pcall(require, 'cmp')
if cmp_ok then
    cmp.setup({
        enabled = function()
            return vim.b.cmp_enabled ~= false
        end,
        snippet = {
            expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping(function(fallback)
                local ls = require('luasnip')
                if cmp.visible() then
                    cmp.select_next_item()
                elseif ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                local ls = require('luasnip')
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif ls.jumpable(-1) then
                    ls.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = { { name = 'nvim_lsp' } },
        completion = { completeopt = 'menu,menuone,noinsert', autocomplete = false },
        experimental = { ghost_text = true },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
    })

    cmp.setup.filetype({ 'cs', 'csharp' }, {
        completion = { autocomplete = { cmp.TriggerEvent.TextChanged } },
    })
end

-- TODO: autocommands to enable/disable cmp for current buffer


local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
end)

if vim.fn.executable('dotnet') == 1 then
    require("roslyn").setup({})

    local roslyn_handlers = require("roslyn.lsp.handlers")
    local orig_needs_restore = roslyn_handlers["workspace/_roslyn_projectNeedsRestore"]
    local function run_restore(root)
        if vim.fn.executable('dotnet') ~= 1 then return end
        vim.notify("Running: dotnet restore", vim.log.levels.INFO, { title = "roslyn.nvim" })
        vim.system({ 'dotnet', 'restore' }, { cwd = root }, function(res)
            if res.code == 0 then
                vim.schedule(function()
                    vim.notify("dotnet restore completed", vim.log.levels.INFO, { title = "roslyn.nvim" })
                end)
            else
                vim.schedule(function()
                    vim.notify("dotnet restore failed (code " .. tostring(res.code) .. ")", vim.log.levels.ERROR,
                        { title = "roslyn.nvim" })
                end)
            end
        end)
    end

    local handlers = vim.tbl_extend('force', roslyn_handlers, {
        ["workspace/_roslyn_projectNeedsRestore"] = function(err, params, ctx, config)
            local orig_result
            if type(orig_needs_restore) == 'function' then
                local ok, r = pcall(orig_needs_restore, err, params, ctx, config)
                if ok and r ~= nil then orig_result = r end
            end
            local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
            local root = client and client.config and client.config.root_dir or vim.fn.getcwd()
            run_restore(root)
            return orig_result ~= nil and orig_result or vim.NIL
        end,
    })

    vim.lsp.config("roslyn", {
        filetypes = { "cs", "csharp" },
        workspace_required = false,
        handlers = handlers,
        capabilities = capabilities,
        opts = {
            filewatching = "nvim",
        }
    })

    local function roslyn_notify_file(uri, change_type)
        for _, client in ipairs(vim.lsp.get_clients({ name = 'roslyn' })) do
            client:notify('workspace/didChangeWatchedFiles', {
                changes = { { uri = uri, type = change_type } },
            })
        end
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.cs',
        callback = function(args)
            local fname = vim.api.nvim_buf_get_name(args.buf)
            local exists = vim.fn.filereadable(fname) == 1
            vim.b[args.buf].roslyn_was_new_cs = not exists
        end,
    })

    vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*.cs',
        callback = function(args)
            local fname = vim.api.nvim_buf_get_name(args.buf)
            if fname == '' then return end
            local uri = vim.uri_from_fname(fname)
            local was_new = vim.b[args.buf].roslyn_was_new_cs
            if was_new then
                roslyn_notify_file(uri, 1) -- Created
            else
                roslyn_notify_file(uri, 2) -- Changed
            end
            vim.b[args.buf].roslyn_was_new_cs = nil
        end,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "roslyn"
                and client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
            end
        end,
    })
else
    vim.notify('Roslyn LSP unavailable (install .NET SDK)', vim.log.levels.WARN)
end

vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = {
            workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
            telemetry = { enable = false },
        }
    }
})


vim.lsp.enable({ 'roslyn' })

vim.api.nvim_create_user_command('StartLsp', function(opts)
    local server = opts.args ~= '' and opts.args or nil
    if not server then
        local ft = vim.bo.filetype
        local map = {
            c = 'clangd',
            cpp = 'clangd',
            cuda = 'clangd',
            lua = 'lua_ls',
            cs = 'roslyn',
            csharp = 'roslyn',
        }
        server = map[ft]
    end
    if not server then
        vim.notify('No LSP mapped for this filetype. Pass a server: :StartLsp <server>', vim.log.levels.WARN)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        client:stop()
    end

    local configs = {
        clangd = {
            name = 'clangd',
            cmd = { 'clangd' },
            root_dir = vim.fs.root(bufnr, { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' }) or vim.fn.getcwd(),
        },
    }

    local config = configs[server]
    if not config then
        vim.notify('No config defined for server: ' .. server, vim.log.levels.ERROR)
        return
    end

    if server == 'clangd' then
        config = vim.tbl_deep_extend('force', config, { capabilities = capabilities })
    end

    local client_id = vim.lsp.start(config, { bufnr = bufnr })
    if not client_id then
        vim.notify('Failed to start LSP server: ' .. server, vim.log.levels.ERROR)
    end
end, { nargs = '?' })

vim.api.nvim_create_user_command('StopLsp', function(opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local server_name = opts.args ~= '' and opts.args or nil

    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if server_name then
        local stopped = false
        for _, client in ipairs(clients) do
            if client.name == server_name then
                client.stop()
                stopped = true
            end
        end
        if not stopped then
            vim.notify('No active LSP found with name: ' .. server_name, vim.log.levels.WARN)
        end
    else
        for _, client in ipairs(clients) do
            client.stop()
        end
    end
end, { nargs = '?' })

local nvim_dir = vim.fn.stdpath('config')
local snippets_dir = nvim_dir .. '/snippets/'
require("luasnip.loaders.from_lua").load({
    paths = { snippets_dir },
})
local ls = require("luasnip")
vim.keymap.set("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

function _G.statusline()
    local branch = vim.b.gitsigns_head or ''
    if branch ~= '' then
        branch = '  ' .. branch .. ' '
    end

    local function cwd_context()
        local full = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
        local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        return string.format('[%s: %s]', project, full)
    end

    local cwd = cwd_context()
    local time = os.date('%H:%M')

    return table.concat({
        '%f',
        branch,
        cwd,
        '%m%r',
        '%=',
        '%l:%c',
        ' (%p%%, %Ll)',
        time,
        '  '
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
vim.keymap.set('t', '<C-q>', [[<C-\><C-n>]])
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>')
vim.keymap.set('n', '<leader>to', ':tabonly<CR>')
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>')

vim.keymap.set('n', '<leader>q', function()
    local choice = vim.fn.confirm("?Wad?? u wanna Quit?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.cmd('qa')
    end
end)

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
        vim.keymap.set('i', '<C-S>', vim.lsp.buf.signature_help, opts)

        vim.keymap.set('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
        end, opts)

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

vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    callback = function(event)
        local ft = vim.bo[event.buf].filetype
        local make_file = nvim_dir .. '/make/' .. ft .. '.lua'
        if vim.fn.filereadable(make_file) == 1 then
            dofile(make_file)
        end
    end,
})

if vim.loop.os_uname().sysname == 'Windows_NT' then
    -- vim.opt.shell = 'pwsh'
    -- vim.opt.shellcmdflag = '-nologo -noprofile -ExecutionPolicy RemoteSigned -command'
    -- vim.opt.shellxquote = ''
    vim.o.shell = vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell'

    vim.o.shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command'

    vim.cmd([[
      let &shellcmdflag .= " [Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSStyle.OutputRendering='PlainText';"
    ]])

    vim.o.shellredir = '2>&1 | Out-File %s; exit $LastExitCode'
    vim.o.shellpipe  = '2>&1 | Tee-Object %s; exit $LastExitCode'

    vim.o.shellquote = ''
    vim.o.shellxquote = ''
else
    vim.opt.shell = '/bin/zsh'
end
