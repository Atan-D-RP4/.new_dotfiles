function! MakeSession()
	let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
	if (filewritable(b:sessiondir) != 2)
		exe 'silent !mkdir -p ' b:sessiondir
		redraw!
	endif
	let b:filename = b:sessiondir . '/session.vim'
	exe "mksession! " . b:filename
endfunction

function! LoadSession()
	let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
	let l:sessionfile = b:sessiondir . "/session.vim"
	let l:lockfile = b:sessiondir . "/session.lock"
	if (filereadable(l:sessionfile) && !filereadable(l:lockfile))
		" Create a lock file
		exe 'silent !touch ' . l:lockfile
		exe 'source ' l:sessionfile
		echo "Session loaded."
	else
		echo "No session loaded (either no session exists or it's already in use)."
	endif
endfunction

function! ClearSession()
	let l:sessiondir = $HOME . "/.vim/sessions" . getcwd()
	let b:sessionfile = l:sessiondir . "/session.vim"
	let l:lockfile = l:sessiondir . "/session.lock"
	if (filereadable(l:lockfile))
		exe 'silent !rm ' l:lockfile
		if (filereadable(b:sessionfile))
			exe 'silent !rm ' b:sessionfile
		endif
		redraw!
		echo "Session cleared."
	else
		echo "No session to clear for " . l:sessiondir
	endif
endfunction

" Function to remove the lock file when Vim exits
function! RemoveLock()
	let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
	let l:lockfile = b:sessiondir . "/session.lock"
	if (filereadable(l:lockfile))
		exe 'silent !rm ' l:lockfile
	endif
endfunction

" Adding automatons for when entering or leaving Vim
au VimEnter * nested :call LoadSession()
au VimLeave * :call MakeSession()
au VimLeave * :call RemoveLock()
