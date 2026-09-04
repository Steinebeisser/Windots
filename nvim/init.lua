vim.g.mapleader = ' '
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_man = 1
vim.g.loaded_osc52 = 1
vim.g.loaded_editorconfig = 1
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
-- vim.opt.swapfile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = {
    tab = '→ ',
    -- space = '·',
    nbsp = '⍽'
}
vim.opt.title = true
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false
vim.opt.confirm = true
vim.opt.completeopt = 'menuone,noinsert'
vim.opt.pumheight = 15
vim.opt.laststatus = 3
vim.filetype.add {
    extension = {
        ebnf = "ebnf",
        cshtml = "razor",
        razor  = "razor",
    },
}
vim.cmd('syntax on')
vim.cmd('colorscheme gruber-darker')
vim.cmd('filetype plugin indent on')
vim.cmd('set tags=./tags,tags;$HOME')
vim.api.nvim_create_autocmd("FileType", {
    pattern = "ebnf",
    callback = function()
        vim.lsp.buf_attach_client(
            0,
            vim.lsp.start_client {
                name = "ebnfer",
                cmd = { "ebnfer" },
                on_attach = on_attach,
                capabilities = capabilities,
            }
        )
    end,
})
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.asm",
    callback = function()
        vim.bo.filetype = "fasm"
    end,
})
vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*.def",
    callback = function()
        vim.bo.filetype = "c"
    end,
})
vim.api.nvim_create_user_command("Tags", function()
    vim.fn.system("ctags -R .")
end, {})
local bg_state = {
    active = false,
    saved = {}
}
local function save_highlight(group)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and hl then
        bg_state.saved[group] = {
            bg = hl.bg,
            ctermbg = hl.ctermbg,
        }
    end
end
local function restore_highlight(group)
    local saved = bg_state.saved[group]
    if saved then
        vim.api.nvim_set_hl(0, group, {
            bg = saved.bg,
            ctermbg = saved.ctermbg,
        })
    end
end
vim.api.nvim_create_user_command("ToggleTransparent", function()
    if not bg_state.active then
        save_highlight("Normal")
        save_highlight("NonText")
        vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
        vim.api.nvim_set_hl(0, "NonText", { bg = "none", ctermbg = "none" })
        bg_state.active = true
        print("Transparency enabled")
    else
        restore_highlight("Normal")
        restore_highlight("NonText")
        bg_state.active = false
        print("Transparency disabled")
    end
end, {})
vim.cmd('highlight NbspWhitespace ctermbg=red guibg=red')
vim.cmd('2match NbspWhitespace /\\%u00a0/')
vim.api.nvim_create_user_command(
    'FixNbsp',
    ':%s/\\%u00a0/ /g',
    {}
)
pcall(vim.loader.enable)
-- plugins
vim.pack.add({
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/echasnovski/mini.pick' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/seblyng/roslyn.nvim' },
    { src = 'https://github.com/nvim-mini/mini.tabline' },
    { src = 'https://github.com/nvim-mini/mini.align' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = 'https://github.com/hrsh7th/nvim-cmp' },
    { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
    { src = 'https://github.com/Eandrju/cellular-automaton.nvim' },
    { src = 'https://github.com/alec-gibson/nvim-tetris' },
    {
        src = 'https://github.com/chomosuke/typst-preview.nvim',
        version = 'v1.4.1'
    },
    { src = 'https://github.com/Civitasv/cmake-tools.nvim' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/Groveer/plantuml.nvim' },
    { src = 'https://github.com/brianhuster/live-preview.nvim' },
    { src = 'https://github.com/tpope/vim-fugitive' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/citizenharris/neotest-dotnet' },
    { src = 'https://github.com/mfussenegger/nvim-dap' },
    { src = 'https://github.com/rcarriga/nvim-dap-ui' },
    { src = 'https://github.com/nvim-neotest/nvim-nio' },
})
require('livepreview.config').set()
require('render-markdown').setup()
require 'mini.tabline'.setup()
require 'oil'.setup()
require 'mini.pick'.setup()
require 'mini.align'.setup({
    mappings = {
        start = 'ga',
        start_with_preview = 'gA',
    },
    options = {
        split_pattern = '',
        justify_side = 'left',
        merge_delimiter = ' ',
    },
})
require('mason').setup({
    registries = {
        'github:mason-org/mason-registry',
        'github:Crashdummyy/mason-registry',
    },
})
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'clangd'
    },
    automatic_enable = {},
})
require("luasnip").setup({ enable_autosnippets = true })
require("plantuml").setup()
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
        }),
        sources = { { name = 'nvim_lsp' } },
        completion = { completeopt = 'menuone,noinsert' },
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
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
end)
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
        Lua = {
            workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
            telemetry = { enable = false },
        }
    }
})
vim.lsp.enable({ 'lua_ls' })
vim.lsp.config('protols', {
    capabilities = capabilities
})
vim.lsp.enable({ 'roslyn', 'protols' })
vim.lsp.config('roslyn', {
    capabilities = capabilities,
    filetypes = { "razor", "cs" },
    settings = {
        ['csharp|background_analysis'] = {
            dotnet_analyzer_diagnostics_scope = 'fullSolution',
            dotnet_compiler_diagnostics_scope = 'fullSolution',
        },
        ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ['csharp|symbol_search'] = {
            dotnet_search_reference_assemblies = true,
        },
        ['csharp|completion'] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_provide_regex_completions = true,
        },
        ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
        },
    },
})
require('roslyn').setup({
    filewatching = 'roslyn',
    broad_search = true,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    pattern = '*.cs',
    callback = function(args)
        if vim.api.nvim_buf_line_count(args.buf) > 1 then return end
        local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ''
        if first_line ~= '' then return end
        local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ':p')
        local csproj = vim.fs.find(function(name)
            return name:match('%.csproj$') ~= nil
        end, { path = vim.fs.dirname(filepath), upward = true })[1]
        if not csproj then return end
        local proj_dir = vim.fs.dirname(csproj)
        local root_ns = vim.fn.fnamemodify(csproj, ':t:r')
        local rel = vim.fs.dirname(filepath):sub(#proj_dir + 2)
        local parts = { root_ns }
        for part in rel:gmatch('[^/\\]+') do
            table.insert(parts, part)
        end
        vim.api.nvim_buf_set_lines(args.buf, 0, 1, false, { 'namespace ' .. table.concat(parts, '.') .. ';', '', })
    end,
})
local dap = require('dap')
dap.set_log_level('TRACE')
local dapui = require('dapui')
dapui.setup()
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
dap.adapters.coreclr = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe',
    args = { '--interpreter=vscode' },
    options = {
        detached = false,
    },
}
local function dotnet_get_dll_path()
    local csproj = vim.fs.find(function(name) return name:match('%.csproj$') end, {
        upward = true,
        path = vim.fn.expand('%:p:h'),
    })[1]
    if not csproj then
        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end
    local proj_dir = vim.fs.dirname(csproj)
    local name = vim.fn.fnamemodify(csproj, ':t:r')
    local candidates = vim.fn.globpath(proj_dir .. '/bin/Debug', '**/' .. name .. '.dll', false, true)
    if #candidates == 0 then
        return vim.fn.input('Path to dll: ', proj_dir .. '/bin/Debug/', 'file')
    end
    table.sort(candidates, function(a, b)
        return vim.fn.getftime(a) > vim.fn.getftime(b)
    end)
    return candidates[1]
end
local function dotnet_build_and_get_dll()
    local csproj = vim.fs.find(function(name) return name:match('%.csproj$') end, {
        upward = true,
        path = vim.fn.expand('%:p:h'),
    })[1]
    if csproj then
        local dir = vim.fs.dirname(csproj)
        vim.fn.system({
            'dotnet', 'build', dir,
            '-c', 'Debug',
            '/p:DebugType=portable',
            '/p:DebugSymbols=true',
            '/p:Optimize=false',
        })
    end
    return dotnet_get_dll_path()
end
dap.configurations.cs = {
    {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
            if vim.fn.confirm('Rebuild first?', '&Yes\n&No', 1) == 1 then
                return dotnet_build_and_get_dll()
            end
            return dotnet_get_dll_path()
        end,
        cwd = function()
            local csproj = vim.fs.find(function(name) return name:match('%.csproj$') end, {
                upward = true,
                path = vim.fn.expand('%:p:h'),
            })[1]
            if csproj then
                return vim.fs.dirname(csproj)
            end
            return vim.fn.getcwd()
        end,
        env = {
            ASPNETCORE_ENVIRONMENT = 'Development',
        },
        justMyCode = false,
        stopAtEntry = false,
        console = 'integratedTerminal',
    },
}
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<leader>d', function() require('dap').continue() end)
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticWarn', linehl = 'CursorLine' })
vim.fn.sign_define('DapBreakpointRejected', { text = '✗', texthl = 'DiagnosticError' })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "razor", "html", "cs" },
    callback = function()
        vim.treesitter.start()
    end,
})
vim.lsp.enable({ 'html' })
vim.lsp.config.html = {
    filetypes = { "razor", "html", "css" },
    init_options = {
        provideFormatter = false,
    },
}
vim.lsp.enable({ 'ts_ls' })
vim.lsp.config.ts_ls = {
    filetypes = { "razor", "javascript", "typescript" },
}
vim.lsp.enable({ 'clangd' })
vim.lsp.enable({ 'cssls' })
vim.lsp.enable({ 'pyright' })
vim.lsp.enable({ 'zls' })
vim.lsp.config.tinymist = {
    filetypes = { 'typst' },
    root_markers = { 'typst.toml', '.git' },
    capabilities = capabilities,
    settings = {
        tinymist = {
            exportPdf = 'onSave',
        }
    }
}
vim.lsp.enable('tinymist')
vim.lsp.config.ltex_plus = {
    filetypes = {
        'markdown',
        'typst'
    },
    settings = {
        ltex = {
            language = 'de-DE',
            checkFrequency = "save",
            additionalRules = {
                enablePickyRules = true,
                motherTongue = 'de-DE',
            },
            completionEnabled = true,
        }
    }
}
vim.lsp.enable('ltex_plus')
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
    local bom = vim.bo.bomb and 'BOM' or ''
    local branch = vim.b.gitsigns_head or ''
    if branch ~= '' then
        branch = '  ' .. branch .. ' '
    end
    local project = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    local function cwd_context()
        local full = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
        return string.format('[%s: %s]', project, full)
    end
    local cwd = cwd_context()
    local time = os.date('%H:%M')
    return table.concat({
        '%f',
        bom,
        branch,
        -- cwd,
        project,
        '%m%r',
        '%=',
        '%l:%c',
        ' (%p%%, %Ll)',
        time,
        '  '
    }, ' ')
end
local timer = vim.uv.new_timer()
if timer ~= nil then
end
local function files_with_hidden()
    MiniPick.builtin.cli({
        command = { 'rg', '--files', '--hidden', '--color=never', '--no-messages' },
    }, {
        source = { name = 'Files (with hidden)' },
    })
end
vim.opt.statusline = '%!v:lua.statusline()'
vim.keymap.set('v', '<leader>y', '"*y')
vim.keymap.set('v', '<leader>p', '"*p')
vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>ff', ':Pick files<CR>')
vim.keymap.set('n', '<leader>fq', files_with_hidden)
vim.keymap.set('n', '<leader>fh', ':Pick help<CR>')
vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>bb', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>br', ':Pick buffers<CR>')
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>')
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')
vim.keymap.set('n', '<leader>qo', ':copen<CR>')
vim.keymap.set('n', '<leader>qc', ':cclose<CR>')
vim.keymap.set('n', '<leader>qn', ':cnext<CR>')
vim.keymap.set('n', '<leader>qp', ':cprev<CR>')
vim.keymap.set('n', '<leader>lo', ':lopen<CR>')
vim.keymap.set('n', '<leader>lc', ':lclose<CR>')
vim.keymap.set('n', '<leader>ln', ':lnext<CR>')
vim.keymap.set('n', '<leader>lp', ':lprev<CR>')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
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
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton game_of_life<CR>")
vim.keymap.set("n", "<leader>fmm", "<cmd>CellularAutomaton make_it_rain<CR>")
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
local group = vim.api.nvim_create_augroup("SteinShellRc", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = ".shellrc",
    group = group,
    callback = function()
        vim.bo.filetype = "stein_shellrc"
        vim.bo.commentstring = ": %s"
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
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, opts)
        vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set('n', '<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
        end, opts)
        if client and client.name ~= "clangd" and client:supports_method('textDocument/formatting') then
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
    vim.o.shellslash   = false
    vim.o.shell        = vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell'
    vim.o.shellcmdflag =
        '-NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command ' ..
        '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();' ..
        "$PSDefaultParameterValues['Out-File:Encoding']='utf8';" ..
        "$PSStyle.OutputRendering = 'PlainText';" ..
        'Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
    vim.o.shellredir   = '2>&1 | Out-File -Encoding UTF8 "%s"; exit $LastExitCode'
    vim.o.shellpipe    = '2>&1 | Tee-Object -Encoding UTF8 "%s"; exit $LastExitCode'
    vim.o.shellquote   = ''
    vim.o.shellxquote  = ''
else
    vim.opt.shell = '/bin/zsh'
end
