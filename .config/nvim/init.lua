vim.cmd([[
source ~/.vim/scripts/vim-sessionizer.vim

" Other Vimscript configurations
set t_Co=256
set t_ut=

if has ('termguicolors')
    set termguicolors
endif

if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

set background=dark
colorscheme wildcharm

syntax on
let c_comment_strings=1

hi Normal guibg=NONE ctermbg=NONE

" Commands and Autocommands
command! ClearTrailingSpaces call ClearTrailingSpaces()
command! AutoIndent call AutoIndent()
command! ToggleNetrw call ToggleNetrw()
command! CFmt call CFmt() | redraw!

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

autocmd FileType txt setlocal! textwidth=147 wrap spell
autocmd FileType rust setlocal! makeprg=clear;\ cargo
autocmd FileType python setlocal! makeprg=clear;\ python3
autocmd FileType c setlocal! makeprg=clear;\ make

autocmd BufWritePre *.rs execute 'RustFmt'
autocmd BufWritePre *.c execute 'CFmt'

if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

filetype plugin indent on

augroup vimStartup
    au!
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif
    autocmd BufWinEnter * if &modifiable | %s/\s\+$//e | endif
augroup END

augroup vimrc_ex
    au!
    autocmd FileType markdown setlocal! textwidth=190
    autocmd FileType text setlocal! textwidth=147
    autocmd FileType text setlocal! spell
    autocmd FileType html setlocal! nowrap
augroup END

augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg=#afff5f gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg=#5fffff gui=underline ctermfg=81 cterm=underline
augroup END
]])

-- Lua configurations
local opt = vim.opt
local g = vim.g

-- Functions

local function mkdir(dir)
    local ok, err = vim.loop.fs_mkdir(dir, 493)
    if not ok then
        if err ~= 'EEXIST' then
			print('Error creating directory: ' .. err)
        end
    end
end

function MoveLines(offset)
    local first_line = vim.fn.line("'<")
    local last_line = vim.fn.line("'>")
    local col = vim.fn.virtcol('.')
    offset = tonumber(offset)

    local target_line = offset > 0 and last_line + offset or first_line + offset
    vim.cmd(string.format('silent! :%d,%dm%d', first_line, last_line, target_line))
    vim.cmd('normal! ' .. col .. '|')
end

-- Move visual selection up or down
function MoveVisualSelection(offset)
    local save_cursor = vim.fn.getpos('.')
    local delta = offset < 0 and -1 or 1
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")

    if offset < 0 then
        if start_line > 1 then
            vim.cmd(string.format('%d,%dmove %d', start_line, end_line, start_line + delta - 1))
        end
    else
        if end_line < vim.fn.line('$') then
            vim.cmd(string.format('%d,%dmove %d', start_line, end_line, end_line + delta))
        end
    end

    vim.fn.setpos('.', save_cursor)
    vim.cmd('normal! gv')
end

-- Toggle Netrw
local NetrwIsOpen = false
function ToggleNetrw()
    if NetrwIsOpen then
        for i = vim.fn.bufnr('$'), 1, -1 do
            if vim.fn.getbufvar(i, '&filetype') == 'netrw' then
                vim.cmd('silent bwipeout ' .. i)
            end
        end
        NetrwIsOpen = false
    else
        NetrwIsOpen = true
        vim.cmd('silent Explore')
    end
end

-- Clear trailing spaces
function ClearTrailingSpaces()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
end

-- Auto indent
function AutoIndent()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.cmd('normal! gg=G')
    vim.fn.setpos('.', save_cursor)
end

-- C Format
function CFmt()
    local save_cursor = vim.fn.getpos('.')
    if vim.fn.executable('clang-format') == 1 then
        local style = "{BasedOnStyle: llvm, IndentWidth: 4, SpaceAfterCStyleCast: true, SpaceBeforeCpp11BracedList: true}"
        local opts = '--style="' .. style .. '"' .. " --sort-includes"
        local buffer_text = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        buffer_text = table.concat(buffer_text, "\n")
        local cmd = 'clang-format ' .. opts
        local formatted = vim.fn.systemlist(cmd, buffer_text)
        vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted)
        vim.cmd('redraw')
    else
        print('clang-format executable not found')
        print('install with `sudo apt install clang-format`')
    end
    vim.fn.setpos('.', save_cursor)
end

-- bindings
vim.api.nvim_set_keymap('n', 'Q', 'gq', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-U>', '<C-G>u<C-U>', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-c>', '<Esc><Esc>', {noremap = true})
vim.api.nvim_set_keymap('i', '<Esc>', '<Esc><Esc>', {noremap = true})
vim.api.nvim_set_keymap('n', '<CR>', ':noh<CR><ESC>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader><CR>', 'i<CR><Esc>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><BS>', 'dd', {noremap = true})
vim.api.nvim_set_keymap('n', "<leader>'", ':terminal fish<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-n>', ':ToggleNetrw<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>]', ':bnext!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>[', ':bprevious!<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>d', ':bdelete! %<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>u', ':edit! #<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '(;', '(<CR>);<Esc>O', {noremap = true})
vim.api.nvim_set_keymap('i', '(,', '(<CR>),<Esc>O', {noremap = true})
vim.api.nvim_set_keymap('i', '{;', '{<CR>};<Esc>O', {noremap = true})
vim.api.nvim_set_keymap('i', '{,', '{<CR>},<Esc>O', {noremap = true})
vim.api.nvim_set_keymap('i', '[;', '[<CR>];<Esc>O', {noremap = true})
vim.api.nvim_set_keymap('i', '[,', '[<CR>],<Esc>O', {noremap = true})
vim.api.nvim_set_keymap('i', '{<CR>', '{<CR>}<Esc>O', {noremap = true})
vim.api.nvim_set_keymap('n', '<S-w>', 'b', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<S-w>', 'b', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S>', ':update<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-S>', '<Esc>:update<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-S>', '<Esc>:update<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', ':lua MoveLines(-2)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', ':lua MoveLines(1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-Up>', ':lua MoveLines(-2)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-Down>', ':lua MoveLines(1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-k>', ':lua MoveVisualSelection(1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-j>', ':lua MoveVisualSelection(-2)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-Up>', ':lua MoveVisualSelection(-2)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-Down>', ':lua MoveVisualSelection(1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-k>', '<C-o>:m-2<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-j>', '<C-o>:m+1<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-Up>', '<C-o>:m-2<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<C-Down>', '<C-o>:m+1<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-q>', '<C-u>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-q>', '<C-u>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true})
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = false})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = false})
vim.api.nvim_set_keymap('v', 'j', 'gj', {noremap = false})
vim.api.nvim_set_keymap('v', 'k', 'gk', {noremap = false})
vim.api.nvim_set_keymap('n', ':', 'q:', {noremap = true})
vim.api.nvim_set_keymap('n', '<Esc>', '<C-c><C-c>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>;', ':<Up><CR>', {noremap = true, silent = true})

-- Functions for moving lines (these need to be defined)
function MoveLines(direction)
    local current_line = vim.fn.line('.')
    local target_line = current_line + direction
    vim.cmd(current_line .. 'move ' .. target_line)
    vim.cmd('normal! ==')
end

function MoveVisualSelection(direction)
    vim.cmd("'<,'>move '" .. (vim.fn.line("'<") + direction))
    vim.cmd('normal! gv=gv')
end

-- General settings
opt.clipboard = 'unnamedplus,unnamed'
opt.path:append('**')
opt.autoread = true
opt.laststatus = 2
opt.lazyredraw = true
opt.smarttab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.smartindent = true
opt.autoindent = true
opt.textwidth = 80
opt.cursorline = true
opt.cursorcolumn = true
opt.listchars = {eol = '¬', tab = '▸·', trail = '~', extends = '»', precedes = '«', nbsp = '·'}
opt.ignorecase = true
opt.smartcase = true
opt.relativenumber = true
opt.number = true
opt.ruler = true
opt.showcmd = true
opt.showmatch = true
opt.showtabline = 2
opt.undolevels = 1000
opt.undoreload = 10000
opt.undofile = true
opt.undodir = '/tmp/.vim/undo.nvim'
opt.history = 10000
opt.swapfile = true
opt.directory = '/tmp/.vim/swap.nvim'
opt.backup = true
opt.backupdir = '/tmp/.vim/backup.nvim'
opt.splitright = true
opt.splitbelow = true
opt.hidden = true
opt.mousehide = true
opt.updatetime = 300
opt.encoding = 'utf-8'
opt.ttimeout = true
opt.ttimeoutlen = 10
opt.timeoutlen = 1000
opt.wildignore = '*.o,*.so*.obj,*~,*swp,*.exe'
opt.wildmenu = true
opt.wildmode = 'longest:full,full'
opt.wildoptions = 'pum,fuzzy'
opt.pumheight = 20
opt.display = 'truncate'
opt.mouse = 'a'
opt.scrolloff = 5
opt.nrformats:remove('octal')
opt.hlsearch = true
opt.incsearch = true

-- Create directories if they don't exist
mkdir(vim.fn.expand('~/.vim/undo.nvim'))
mkdir(vim.fn.expand('~/.vim/backup.nvim'))
mkdir(vim.fn.expand('~/.vim/swap.nvim'))

-- WSL yank support
local clip = '/mnt/c/Windows/System32/clip.exe'
if vim.fn.executable(clip) == 1 then
    vim.api.nvim_create_autocmd('TextYankPost', {
        group = vim.api.nvim_create_augroup('WSLYank', { clear = true }),
        callback = function()
            if vim.v.event.operator == 'y' then
                vim.fn.system(clip, vim.fn.getreg('0'))
            end
        end,
    })
end
