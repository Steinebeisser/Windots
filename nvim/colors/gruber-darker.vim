" gruber-darker.vim - Gruber Darker color theme for Vim
" License: MIT
" Maintainer: Paul Geisthardt
" Latest Revision: 2026-04-19
" Description: Converted from gruber-darker-theme.el by tsoding (Alexey Kutepov/rexim)
" Original Emacs theme based on Gruber Dark for BBEdit by John Gruber

if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "gruber-darker"


set termguicolors
set background=dark
highlight clear

" Color palette
let s:gruber_darker_fg          = "#e4e4ef"
let s:gruber_darker_fg_p1       = "#f4f4ff"
let s:gruber_darker_fg_p2       = "#f5f5f5"
let s:gruber_darker_white       = "#ffffff"
let s:gruber_darker_black       = "#000000"
let s:gruber_darker_bg_m1       = "#101010"
let s:gruber_darker_bg          = "#181818"
let s:gruber_darker_bg_p1       = "#282828"
let s:gruber_darker_bg_p2       = "#453d41"
let s:gruber_darker_bg_p3       = "#484848"
let s:gruber_darker_bg_p4       = "#52494e"
let s:gruber_darker_red_m1      = "#c73c3f"
let s:gruber_darker_red         = "#f43841"
let s:gruber_darker_red_p1      = "#ff4f58"
let s:gruber_darker_green       = "#73c936"
let s:gruber_darker_yellow      = "#ffdd33"
let s:gruber_darker_brown       = "#cc8c3c"
let s:gruber_darker_quartz      = "#95a99f"
let s:gruber_darker_niagara_m2  = "#303540"
let s:gruber_darker_niagara_m1  = "#565f73"
let s:gruber_darker_niagara     = "#96a6c8"
let s:gruber_darker_wisteria    = "#9e95c7"

function! s:hi(group, fg, bg, gui, cterm)
    let l:cmd  = "hi "       .  a:group
    let l:cmd .= " guifg="   . (a:fg    != '' ? a:fg    : 'NONE')
    let l:cmd .= " guibg="   . (a:bg    != '' ? a:bg    : 'NONE')
    let l:cmd .= " gui="     . (a:gui   != '' ? a:gui   : 'NONE')
    let l:cmd .= " ctermfg=" . 'NONE'
    let l:cmd .= " ctermbg=" . 'NONE'
    let l:cmd .= " cterm="   . (a:cterm != '' ? a:cterm : 'NONE')
    execute l:cmd
endfunction

call s:hi('Normal', s:gruber_darker_fg, s:gruber_darker_bg, '', '')

" Cursor
call s:hi('Cursor',     s:gruber_darker_black, s:gruber_darker_yellow, '', '')
call s:hi('iCursor',    s:gruber_darker_black, s:gruber_darker_yellow, '', '')
call s:hi('TermCursor', s:gruber_darker_black, s:gruber_darker_yellow, '', '')
set guicursor=n-v-c-i:block-Cursor

" Line Number
call s:hi('CursorLineNr', s:gruber_darker_yellow, '', '', '')
call s:hi('LineNr',       s:gruber_darker_bg_p4,  '', '', '')
call s:hi('LineNrAbove',  s:gruber_darker_bg_p4,  '', '', '')
call s:hi('LineNrBelow',  s:gruber_darker_bg_p4,  '', '', '')

" Cursor Line
call s:hi('CursorColumn', '', '',                    '', '')
call s:hi('CursorLine',   '', s:gruber_darker_bg_p1, '', '')

" Comment
call s:hi('Comment', s:gruber_darker_brown, '','','')

" String
call s:hi('String', s:gruber_darker_green, '','', '')
call s:hi('cCharacter', s:gruber_darker_green, '', '', '')

" c Specific
call s:hi('cType',      s:gruber_darker_quartz, '', '', '')
call s:hi('cTypedef',   s:gruber_darker_yellow, '', 'bold', '')
call s:hi('cStructure', s:gruber_darker_yellow, '', 'bold', '')
call s:hi('cNumber',    s:gruber_darker_fg,     '', 'bold', '')

" Whitespace
set listchars=tab:»»,space:·,trail:·,nbsp:␣,extends:>,precedes:<
set list
call s:hi('Whitespace',      s:gruber_darker_bg_p1, '',  '', '')
call s:hi('ExtraWhitespace', s:gruber_darker_black, s:gruber_darker_red, '', '')
call s:hi('TabWhitespace',   s:gruber_darker_red,   s:gruber_darker_yellow, '', '')

function! s:clear_ws_matches() abort
  if exists('w:ws_matches')
    for id in w:ws_matches
      call matchdelete(id)
    endfor
  endif
  let w:ws_matches = []
endfunction

function! s:add_ws_matches(insert_mode) abort
  " skip special buffers (terminal, help, etc.)
  if &buftype != ''
    call s:clear_ws_matches()
    return
  endif

  call s:clear_ws_matches()

  let w:ws_matches = []

  if a:insert_mode
    call add(w:ws_matches, matchadd('ExtraWhitespace', '\s\+\%#\@<!$'))
  else
    call add(w:ws_matches, matchadd('ExtraWhitespace', '\s\+$'))
  endif

  call add(w:ws_matches, matchadd('TabWhitespace', '\t'))
endfunction

augroup GruberDarkerWhitespace
  autocmd!
  autocmd BufWinEnter * call s:add_ws_matches(0)
  autocmd InsertEnter * call s:add_ws_matches(1)
  autocmd InsertLeave * call s:add_ws_matches(0)

  autocmd TermOpen * setlocal nolist | call s:clear_ws_matches()
augroup END

" Statusline
call s:hi('StatusLine',   s:gruber_darker_white,  s:gruber_darker_bg_p1, '', '')
call s:hi('StatusLineNC', s:gruber_darker_quartz, s:gruber_darker_bg_p1, '', '')

" Oil
call s:hi('Directory', s:gruber_darker_niagara, '', '', '')

" Visual Mode
call s:hi('Visual',    '', s:gruber_darker_bg_p3, '', '')
call s:hi('VisualNOS', '', s:gruber_darker_bg_p3, '', '')

" Windows splits
call s:hi('VertSplit',    s:gruber_darker_bg_p2, s:gruber_darker_bg_p1, '', '')
call s:hi('WinSeparator', s:gruber_darker_bg_p2, s:gruber_darker_bg_p1, '', '')


" keywords
call s:hi('Statement',    s:gruber_darker_yellow,  '', 'bold', '')
call s:hi('Keyword',      s:gruber_darker_yellow,  '', 'bold', '')
call s:hi('Conditional',  s:gruber_darker_yellow,  '', 'bold', '')
call s:hi('Repeat',       s:gruber_darker_yellow,  '', 'bold', '')
call s:hi('Label',        s:gruber_darker_yellow,  '', 'bold', '')
call s:hi('Exception',    s:gruber_darker_yellow,  '', 'bold', '')
call s:hi('Operator',     '',                      '', '',     '')
call s:hi('Type',         s:gruber_darker_quartz,  '', '',     '')

call s:hi('Special',      s:gruber_darker_yellow,  '','','')
call s:hi('SpecialChar',  s:gruber_darker_green,   '','','')

call s:hi('PreProc',      s:gruber_darker_quartz,   '', '', '')
call s:hi('Constant',      s:gruber_darker_quartz,  '', '', '')
call s:hi('Number',        s:gruber_darker_quartz,  '', '', '')
call s:hi('Boolean',       s:gruber_darker_quartz,  '', '', '')
call s:hi('Float',         s:gruber_darker_quartz,  '', '', '')
call s:hi('Identifier',    s:gruber_darker_fg_p1,   '', '', '')
call s:hi('Underlined',    s:gruber_darker_niagara, '', 'underline', '')

" Other stuff
call s:hi('Function',   s:gruber_darker_niagara, '',                     '',     '')
call s:hi('MatchParen', s:gruber_darker_yellow,  s:gruber_darker_bg_p4,  '',     '')
call s:hi('NonText',    s:gruber_darker_bg_p4,   '',                     '',     '')
call s:hi('Fringe',     s:gruber_darker_bg_p2,   '',                     '',     '')
call s:hi('Underlined', s:gruber_darker_niagara, '',                'underline', '')
call s:hi('WildMenu',   s:gruber_darker_black,   s:gruber_darker_yellow, 'bold', '')
call s:hi('Title',      s:gruber_darker_niagara, '',                     'bold', '')
call s:hi('Todo',       s:gruber_darker_black,   s:gruber_darker_yellow, 'bold', '')
call s:hi('Delimiter',  s:gruber_darker_fg,      '',                     '',     '')
call s:hi('EndOfBuffer',s:gruber_darker_bg_p4,   '',                     '',     '')
call s:hi('Conceal',    s:gruber_darker_quartz,  '',                     '',     '')

" Popup menu
call s:hi('Pmenu',      s:gruber_darker_fg,    s:gruber_darker_bg_p1,  '', '')
call s:hi('PmenuSel',   s:gruber_darker_black, s:gruber_darker_yellow, '', '')
call s:hi('PmenuSbar',  '',                    s:gruber_darker_bg_p2,  '', '')
call s:hi('PmenuThumb', '',                    s:gruber_darker_yellow, '', '')


call s:hi('Search',    s:gruber_darker_black, s:gruber_darker_fg_p2, '', '')
call s:hi('CurSearch', s:gruber_darker_black, s:gruber_darker_fg_p2, '', '')
call s:hi('IncSearch', s:gruber_darker_fg_p1, s:gruber_darker_niagara_m1, '', '')

" mini.pick
call s:hi('MiniPickNormal', s:gruber_darker_fg, s:gruber_darker_bg_p1, '', '')
call s:hi('MiniPickBorder', s:gruber_darker_niagara, s:gruber_darker_bg_p1, '', '')
call s:hi('MiniPickBorderBusy', s:gruber_darker_red, s:gruber_darker_bg_p1, '', '')
call s:hi('MiniPickBorderText', s:gruber_darker_quartz, s:gruber_darker_bg_p1, '', '')
call s:hi('MiniPickCursor', '', '', '', '')
call s:hi('MiniPickIconDirectory', s:gruber_darker_niagara, '', '', '')
call s:hi('MiniPickIconFile', s:gruber_darker_fg, '', '', '')
call s:hi('MiniPickHeader', s:gruber_darker_yellow, '', 'bold', '')
call s:hi('MiniPickMatchCurrent', s:gruber_darker_black, s:gruber_darker_yellow, 'bold', '')
call s:hi('MiniPickMatchMarked', s:gruber_darker_green, '', 'bold', '')
call s:hi('MiniPickMatchRanges', s:gruber_darker_yellow, '', 'bold', '')
call s:hi('MiniPickPreviewLine', '', s:gruber_darker_bg_p1, '', '')
call s:hi('MiniPickPreviewRegion', '', s:gruber_darker_bg_p3, '', '')
call s:hi('MiniPickPrompt', s:gruber_darker_niagara, s:gruber_darker_bg_p1, '', '')
call s:hi('MiniPickPromptCaret', s:gruber_darker_yellow, '', '', '')
call s:hi('MiniPickPromptPrefix', s:gruber_darker_yellow, '', '', '')

" mini tabline
call s:hi('MiniTablineCurrent', s:gruber_darker_yellow, s:gruber_darker_bg_p1, 'bold', '')
call s:hi('MiniTablineVisible', s:gruber_darker_fg, s:gruber_darker_bg_p1, '', '')
call s:hi('MiniTablineHidden', s:gruber_darker_bg_p4, s:gruber_darker_bg_p1, '', '')
call s:hi('MiniTablineModifiedCurrent', s:gruber_darker_yellow, s:gruber_darker_bg_p1, 'bold,italic', '')
call s:hi('MiniTablineModifiedVisible', s:gruber_darker_fg, s:gruber_darker_bg_p1, 'italic', '')
call s:hi('MiniTablineModifiedHidden', s:gruber_darker_bg_p4, s:gruber_darker_bg_p1, 'italic', '')
call s:hi('MiniTablineFill', '', s:gruber_darker_bg_p1, '', '')
call s:hi('MiniTablineTabpagesection', s:gruber_darker_niagara, s:gruber_darker_bg_p1, 'bold', '')

" Gitsigns + diff
call s:hi('DiffAdd',    s:gruber_darker_green,   '', '', '')
call s:hi('DiffDelete', s:gruber_darker_red_p1,  '', '', '')
call s:hi('DiffChange', s:gruber_darker_yellow,  '', '', '')
call s:hi('DiffText',   s:gruber_darker_yellow,  s:gruber_darker_bg_p1, '', '')
call s:hi('GitSignsAdd',    s:gruber_darker_green,   '', '', '')
call s:hi('GitSignsChange', s:gruber_darker_yellow,  '', '', '')
call s:hi('GitSignsDelete', s:gruber_darker_red_p1,  '', '', '')

" Floating windows
call s:hi('NormalFloat',   s:gruber_darker_fg,     s:gruber_darker_bg_p1, '', '')
call s:hi('FloatBorder',   s:gruber_darker_niagara, s:gruber_darker_bg_p1, '', '')
call s:hi('DiagnosticError', s:gruber_darker_red,     '', '', '')
call s:hi('DiagnosticWarn',  s:gruber_darker_yellow,  '', '', '')
call s:hi('DiagnosticInfo',  s:gruber_darker_niagara, '', '', '')
call s:hi('DiagnosticHint',  s:gruber_darker_green,   '', '', '')

" Errors/Messages
call s:hi('Error',      s:gruber_darker_red,     '',                    'bold', '')
call s:hi('ErrorMsg',   s:gruber_darker_red,     '',                    '',     '')
call s:hi('WarningMsg', s:gruber_darker_yellow,  '',                    '',     '')
call s:hi('ModeMsg',    s:gruber_darker_green,   '',                    '',     '')
call s:hi('MoreMsg',    s:gruber_darker_green,   '',                    '',     '')
call s:hi('Question',   s:gruber_darker_green,   '',                    '',     '')

" Spell
call s:hi('SpellBad',   s:gruber_darker_red,      '', 'undercurl', '')
call s:hi('SpellCap',   s:gruber_darker_yellow,   '', 'undercurl', '')

" Treesitter
call s:hi('@punctuation.bracket',   s:gruber_darker_fg,      '', '', '')
call s:hi('@punctuation.delimiter', s:gruber_darker_fg,      '', '', '')
call s:hi('@punctuation.special',   s:gruber_darker_fg,      '', '', '')
call s:hi('@type',                  s:gruber_darker_quartz,  '', '', '')
call s:hi('@type.builtin',          s:gruber_darker_quartz,  '', '', '')
call s:hi('@constant',              s:gruber_darker_quartz,  '', '', '')
call s:hi('@constant.builtin',      s:gruber_darker_quartz,  '', '', '')
call s:hi('@variable.member',       s:gruber_darker_fg_p1,   '', '', '')
call s:hi('@property',              s:gruber_darker_fg_p1,   '', '', '')
call s:hi('@variable.parameter',    s:gruber_darker_fg_p1,   '', '', '')
call s:hi('@module',                s:gruber_darker_niagara, '', '', '')


" builtins
call s:hi('@function.builtin',      s:gruber_darker_yellow, '', '', '')
call s:hi('@function.builtin.lua',  s:gruber_darker_yellow, '', '', '')

" variables
call s:hi('@variable',     s:gruber_darker_fg_p1, '', '', '')
call s:hi('@variable.lua', s:gruber_darker_fg_p1, '', '', '')

" folds
call s:hi('Folded',      s:gruber_darker_quartz,  s:gruber_darker_bg_p1, '', '')
call s:hi('FoldColumn',  s:gruber_darker_bg_p4,   s:gruber_darker_bg,    '', '')
call s:hi('ColorColumn', '',                      s:gruber_darker_bg_p1, '', '')

" links
call s:hi('link-visited',   s:gruber_darker_wisteria, '', 'underline', '')
