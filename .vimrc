" Plugins And Configurations----

" Adds fzf when installed from apt. Files does not work here though
" set rtp+=/usr/share/doc/fzf/examples/fzf.vim

call plug#begin()

"Other Plugins
" ------

Plug 'justinmk/vim-sneak'


" Peeking into registers
Plug 'junegunn/vim-peekaboo'

" Better Command Line
Plug 'paradigm/SkyBison'

" Mulitple Cursors
" Plug 'mg979/vim-visual-multi'
" Plug 'terryma/vim-multiple-cursors'

" Line Motion Assist Plugin
Plug 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars=150

" Copilot
Plug 'github/copilot.vim'

" Status Line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='alduin'

" Indentation for Python
Plug 'vim-scripts/indentpython.vim'

" File tree and fuzzy search
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', "{ 'dir': '~/.fzf', 'do': './install --all' }
let g:fzf_command = 'rg --files -L' " Set fzf command to use ripgrep (optional)

Plug 'mbbill/undotree'

"NERDTree
" Plug 'preservim/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Display number of lines in files
" let g:NERDTreeFileLines = 1

" Git
Plug 'tpope/vim-fugitive'

" LSP and LanguageClient Plugins
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/vim-lsp'
let g:lsp_semantic_enabled = 1
let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_use_event_queue = 1
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.vim/lsp.log')
let g:lsp_inlay_hints_enabled = 1

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
let g:async_complete_min_chars = 3
let g:asyncomplete_auto_completeopt = 0

source ~/.vim/scripts/lsp_conf.vim

Plug 'mattn/emmet-vim'

Plug 'preservim/nerdcommenter'
let g:NERDCreateDefaultMappings = 1 " Create default mappings
let g:NERDSpaceDelims = 1 " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1 " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left' " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1 " Set a language to use its alternate delimiters by default
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } } " Add your own custom formats or override the defaults
let g:NERDCommentEmptyLines = 1 " Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1 " Enable trimming of trailing whitespace when uncommenting
let g:NERDToggleCheckAllLines = 1 " Enable NERDCommenterToggle to check all selected lines is commented or not

" LaTeX
" Plug 'lervag/vimtex'

" Other Plugins
" ------

call plug#end()

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
	packadd! matchit
endif

" Debugger
packadd! termdebug
let g:termdebug_variables_window = 15

"===========================================================================================================

"         Vanilla Configurations----

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
	finish
endif

"Auto install Plug https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Vim Sessions script
source ~/.vim/scripts/vim-sessionizer.vim

if has('unnamedplus')
	set clipboard=unnamedplus,unnamed
else
	set clipboard+=unnamed
endif

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
	augroup WSLYank
		autocmd!
		autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
	augroup END
endif


" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
set nocompatible
silent! endwhile

set t_Co=256						" Set terminal colors to 256
set t_ut=							" Set terminal to true color
set term=xterm-256color				" Set terminal to 256 colors

if has ('termguicolors')
	set termguicolors                 " Enable true colors
endif

if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=0
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
	set csverb
endif


set background=dark					" Set background to dark
colorscheme wildcharm

" set autochdir						" Change directory to the file in the current buffer
set path+=** 						" Search for files in subdirectories
set autoread						" Automatically reload files when changed outside of Vim
set nocompatible					" Use Vim settings, not Vi settings
set laststatus=2
set lazyredraw

set smarttab
set tabstop=4						" Sets tab width to 4 spaces
set shiftwidth=4 					" Sets indent width to 4 spaces
set noexpandtab						" Do not use spaces for tabs
set smartindent						" Smart indentation
set autoindent						" Automatic indentation
set textwidth=80					" Set text width to 80 characters
set cursorline						" Highlight the current line
set cursorcolumn					" Highlight the current column

set listchars=eol:↵,tab:→·,trail:~,extends:↷,precedes:↶,nbsp:·

" Useful to keep this in mind when comparing files or debugging
" set diffopt+=vertical				" Open diff in vertical split
" if has('diff')
"	 set diffopt+=internal,algorithm:patience
"	 set cursorbind					" Keeps cursors on the same line in different windows
" endif

set ignorecase						" Ignores case, required for smartcase
set smartcase						" Smart cased searched
set relativenumber 					" Shows relative line numbers
set number						    " Shows current line number
set backspace=indent,eol,start		" Allow backspacing over everything in insert mode.

set ruler						    " Show the cursor position all the time
set showcmd							" Display partial commands in bottom right corner of screen
set showmatch						" Show matching brackets
set showtabline=2

set undolevels=1000                 " How many undos
set undoreload=10000                " Number of lines to save for undo
set undofile						" Save undo history to a file
set undodir=/tmp/.vim/undo		    " Undo files directory

set history=10000				    " Keep 100000 lines of command line history

set swapfile						" Swap files
set directory=/tmp/.vim/swap        " Swap files directory

set backup							" Backup files
set backupdir=/tmp/.vim/backup      " Backups files directory

set splitright     					" Puts new vsplit windows to the right of the current
set splitbelow     					" Puts new split windows to the bottom of the current
set hidden
set mousehide

set updatetime=300					" Time in milliseconds to write swap file
set encoding=utf-8                  " Internal encoding
set ttimeout						" Time out for key codes
set ttimeoutlen=10					" Wait up to 100ms after Esc for special key
set timeoutlen=1000					" Time out for key codes

" Ignore these files when using wildmenu
set wildignore=*.o,*.so*.obj,*~,*swp,*.exe
set wildmenu						" Shows a horizontal list of completion options
set wildmode=longest:full,full		" Command-line completion mode
set wildoptions=pum,fuzzy
set pumheight=20					" Maximum number of items in the popup menu

set display=truncate				" Show @@@ in the last line if it is truncated.
set background=dark                 " Set background to dark
set mouse=a                         " Enable mouse support

" ================= Will only work with no colorscheme =================
"
" Set wildmenu appearance
" highlight WildMenu ctermfg=Red ctermbg=LightBlue

" Customize autocomplete menu appearance
"
" highlight CursorLine   ctermfg=Green guifg=Green ctermbg=LightBlue guibg=Blue
" highlight CursorColumn ctermfg=Green guifg=Green ctermbg=LightBlue guibg=Blue

"autocmd InsertLeave * highlight CursorLine ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
"autocmd InsertLeave * highlight CursorColumn ctermfg=NONE ctermbg=NONE cterm=bold guifg=Black guibg=yellow gui=NONE
" ================= Will only work with no colorscheme =================

autocmd InsertEnter * highlight CursorLine ctermbg=236 guibg=#303045
autocmd InsertEnter * highlight CursorColumn ctermbg=236 guibg=#303045
autocmd InsertLeave * highlight CursorLine ctermbg=NONE guibg=NONE
autocmd InsertLeave * highlight CursorColumn ctermbg=NONE guibg=NONE

set completeopt=menu,menuone,preview,noinsert,noselect

set signcolumn=yes

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
	set incsearch
endif

set nrformats-=octal				" Do not recognize octal numbers for Ctrl-A and Ctrl-X

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
	set guioptions-=t
endif

if has('langmap') && exists('+langremap')
	" Prevent that the langmap option applies to characters that result from a
	" mapping.  If set (default), this may break plugins (but it's backward
	" compatible).
	set nolangremap
endif

if &t_Co > 2 || has("gui_running")
	" Switch on highlighting the last used search pattern.
	set hlsearch
endif

" Make backup folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
	call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
	call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
	call mkdir(expand(&directory), "p")
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
	" Revert with ":syntax off".
	syntax on
	" I like highlighting strings inside C comments.
	" Revert with ":unlet c_comment_strings".
	let c_comment_strings=1
endif

hi Normal guibg=NONE ctermbg=NONE

"===========================================================================================================

"         Functions----

function! LspDocumentSymbolsFzf() abort
	" Get the current buffer name
	let l:current_buffer = expand('%:p')

	" Run the LspDocumentSymbol command to populate the quickfix list
	LspDocumentSymbol

	" Wait for the LSP to finish retrieving the symbols
	" You may need to adjust the sleep time depending on server speed
	sleep 100m

	" Get the current quickfix list (populated by LspDocumentSymbol)
	let l:quickfix_list = getqflist()

	" Close the quickfix window
	cclose

	" Create a list of symbols formatted as 'filename:line:col | symbol name'
	" 'filename' = current buffer name
	let l:symbols = map(l:quickfix_list, {_, v -> l:current_buffer . ':' . v['lnum'] . ':' . v['col'] . ' | ' . v['text']})

	" Pipe the symbols into fzf for fuzzy finding
	" source is in a format not supported by batcat
	call fzf#run(fzf#wrap({
				\ 'source': l:symbols,
				\ 'sink': function('LspJumpToSymbol'),
				\})
				\ )
endfunction

function! LspJumpToSymbol(selected) abort
	" Split the selected result to get the filename, line number, and column
	let l:parts = split(a:selected, ':')
	let l:filename = l:parts[0]
	let l:line = l:parts[1]
	let l:col = l:parts[2]

	" Open the file and jump to the selected symbol
	exec 'edit' l:filename
	call cursor(l:line, l:col)
endfunction

" Move lines up or down in normal mode
function! MoveLines(offset) range
	let l:col = virtcol('.')
	let l:offset = str2nr(a:offset)

	exe 'silent! :' . a:firstline . ',' . a:lastline . 'm'
				\ . (l:offset > 0 ? a:lastline + l:offset : a:firstline + l:offset)

	exe 'normal ' . l:col . '|'
endf

" Move visual selection up or down
function! MoveVisualSelection(offset) range
	" Save current cursor position and visual mode
	let l:save_cursor = getpos('.')

	" Define the direction of movement
	let l:delta = a:offset < 0 ? -1 : 1

	" Get the start and end line numbers based on visual selection
	let l:start_line = a:firstline
	let l:end_line = a:lastline

	" Move lines in the specified direction
	if a:offset < 0
		if l:start_line > 1
			execute l:start_line . ',' . l:end_line . 'move ' . (l:start_line + l:delta - 1)
		endif
	else
		if l:end_line < line('$')
			execute l:start_line . ',' . l:end_line . 'move ' . (l:end_line + l:delta)
		endif
	endif

	" Restore cursor position and visual mode
	call setpos('.', l:save_cursor)
	execute "normal! gv"
endfunction

function! ToggleNetrw()
	if exists("g:NetrwIsOpen")
		if g:NetrwIsOpen
			let i = bufnr("$")
			while (i >= 1)
				if (getbufvar(i, "&filetype") == "netrw")
					silent exe "bwipeout " . i
				endif
				let i-=1
			endwhile
			let g:NetrwIsOpen=0
		else
			let g:NetrwIsOpen=1
			silent Explore
		endif
	else
		let g:NetrwIsOpen=1
		silent Explore
	endif
endfunction

function! ClearTrailingSpaces()
	" Save the cursor position
	let l:save_cursor = getpos('.')

	" Clear trailing spaces
	%s/\s\+$//e

	" Restore the cursor position
	call setpos('.', l:save_cursor)
endfunction

function! AutoIndent()
	" Save the cursor position
	let l:save_cursor = getpos('.')

	" Clear trailing spaces
	%s/\s\+$//e

	execute 'normal! gg=G'

	" Restore the cursor position
	call setpos('.', l:save_cursor)
endfunction

function! CFmt() abort
	let l:save_cursor = getpos('.')

	if executable('clang-format')
		let l:style = "{BasedOnStyle: llvm, IndentWidth: 4, SpaceAfterCStyleCast: true, SpaceBeforeCpp11BracedList: true}"
		let l:opts = '--style="' . l:style . '"' . " --sort-includes"
		let l:buffer_text = getline(1, '$')
		let l:buffer_text = join(l:buffer_text, "\n")
		let l:cmd = 'clang-format ' . l:opts

		let l:formatted = systemlist(l:cmd, l:buffer_text)
		" Replace the text in the buffer with the formatted text
		call setline(1, l:formatted)
		redraw
	else
		echoerr 'clang-format executable not found'
		echoerr 'install with `sudo apt install clang-format`'
	endif

	call setpos('.', l:save_cursor)
endfunction

"===========================================================================================================

"         Commands and Autocommands----

command! ClearTrailingSpaces call ClearTrailingSpaces()
command! AutoIndent call AutoIndent()
command! ToggleNetrw call ToggleNetrw()
command! CFmt call CFmt() | redraw!
" command! FZFArgs call fzf#run(fzf#wrap({'source': argv(), 'options': '--multi'}))

" Jump to last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Set textwidth and enable line wrapping for files with .txt extension
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

" Only do this part when Vim was compiled with the +eval feature.
if 1
	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	" Revert with ":filetype off".
	filetype plugin indent on

	" Put these in an autocmd group, so that you can revert them with:
	" ":augroup vimStartup | exe 'au!' | augroup END"
	augroup vimStartup
		au!

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid, when inside an event handler
		" (happens when dropping a file on gvim) and for a commit message (it's
		" likely a different one than last time).
		autocmd BufReadPost *
					\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
					\ |   exe "normal! g`\""
					\ | endif

		" Write an autocmd to highlight trailing whitespace only if modifiable
		autocmd BufWinEnter * if &modifiable | %s/\s\+$//e | endif
	augroup END
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrc_ex
	au!
	autocmd FileType markdown setlocal! textwidth=190
	" For all text files set 'textwidth' to 147 characters.
	autocmd FileType text setlocal! textwidth=147
	autocmd FileType text setlocal! spell
	autocmd FileType html setlocal! nowrap
augroup END

augroup qs_colors
	autocmd!
	autocmd ColorScheme * highlight QuickScopePrimary guifg=#afff5f gui=underline ctermfg=155 cterm=underline
	autocmd ColorScheme * highlight QuickScopeSecondary guifg=#5fffff gui=underline ctermfg=81 cterm=underline
augroup END

"===========================================================================================================

"        My Keybindings----

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

inoremap <C-c> <Esc><Esc>

" Better keybinding Esc in insert mode
inoremap <Esc> <Esc><Esc>

inoremap <C-L> <Plug>(copilot-accept-word)
inoremap <C-E> <Plug>(copilot-accept-line)
inoremap <C-H> <Plug>(copilot-suggest)

" Deals with search highlighting for me
nnoremap <silent><CR> :noh<CR><ESC>

" Keybinding for opening a new line in normal mode
nnoremap <leader><CR> i<CR><Esc>

" Keybinding for deleting a line in normal mode
nnoremap <leader><BS> dd

" Keybinding for opening terminal
nnoremap <leader>' :terminal fish<CR>

" Keybinding for Toggling NERDTree
" nnoremap <C-n> :NERDTreeToggle<CR>

" Keybinding for Toggling Netrw
nnoremap <C-n> :ToggleNetrw<CR>

" Keybinding for Toggling UndoTree
nnoremap <leader>z :UndotreeToggle<CR>

" Use fzf for file navigation
nnoremap <leader>p  :Files<CR>
nnoremap <leader>o  :Buffers<CR>
nnoremap <leader>m  :Marks<CR>
nnoremap <leader>l  :History<CR>
nnoremap <leader>f  :Rg<CR>

" LSP navigation
nnoremap <leader>sl :LspDocumentSymbolSearch<CR>

" Keymaps for buffer-tabs
nnoremap <silent> <leader>] :bnext!<CR>
nnoremap <silent> <leader>[ :bprevious!<CR>
nnoremap <silent> <leader>d :bdelete! %<CR>
nnoremap <silent> <leader>u :edit! #<CR>

" Auto-expands braces
inoremap (; (<CR>);<Esc>O
inoremap (, (<CR>),<Esc>O
inoremap {; {<CR>};<Esc>O
inoremap {, {<CR>},<Esc>O
inoremap [; [<CR>];<Esc>O
inoremap [, [<CR>],<Esc>O

inoremap {<CR> {<CR>}<Esc>O

imap <C-L> <Plug>(copilot-accept-word)

" Keybindings for navigation
nnoremap <silent> <S-w> b
vnoremap <silent> <S-w> b

" Keybinding for quicksaving
nnoremap <silent> <C-S> :update<CR>
inoremap <silent> <C-S> <Esc>:update <CR>
vnoremap <silent> <C-S> <Esc>:update <CR>

" Keybindings for alt line movement.
nnoremap <silent> <C-k> :call MoveLines(-2)<CR>
nnoremap <silent> <C-j> :call MoveLines(+1)<CR>
nnoremap <silent> <C-Up> :call MoveLines(-2)<CR>
nnoremap <silent> <C-Down> :call MoveLines(+1)<CR>

vnoremap <silent> <C-k> :call MoveVisualSelection(+1)<CR>
vnoremap <silent> <C-j> :call MoveVisualSelection(-2)<CR>
vnoremap <silent> <C-Up> :call MoveVisualSelection(-2)<CR>
vnoremap <silent> <C-Down> :call MoveVisualSelection(+1)<CR>

inoremap <silent> <C-k> <C-o>:m-2 .+<C-r>=v:count1<CR><CR>
inoremap <silent> <C-j> <C-o>:m+ .+<C-r>=v:count1<CR><CR>
inoremap <silent> <C-Up> <C-o>:m-2 .+<C-r>=v:count1<CR><CR>
inoremap <silent> <C-Down> <C-o>:m+ .+<C-r>=v:count1<CR><CR>

" Jump up the file lines
nnoremap <silent> <C-q> <C-u>
vnoremap <silent> <C-q> <C-u>

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Treat long lines as break lines (useful when moving around in them)
nmap j gj
nmap k gk
vmap j gj
vmap k gk

nnoremap : q:
nnoremap <silent> <leader>: :call SkyBison("")<CR>
nnoremap <Esc> <C-c><C-c>

" Keymap for repeating ':' commands
nnoremap <silent> <leader>; :<Up><CR>

" Remapping for vim-sneak
nmap gs <Plug>Sneak_s
nmap gS <Plug>Sneak_S
vmap gs <Plug>Sneak_s
vmap gS <Plug>Sneak_S

"===========================================================================================================

" How to load only default plugins
" Open vim with vim --clean and run (( :for f in glob("path/to/scripts/*.vim", 1, 1) | exe "source" f | endfor ))
