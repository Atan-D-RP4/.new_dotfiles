tnoremap <C-\> <C-\><C-n>| " Enter normal mode
tnoremap <C-w> <C-w>.| " Send native Ctrl-w
tnoremap <C-x><C-w> cd '<C-w>"=getcwd()<CR>'<CR>| " Navigate to Vim's current working directory
tnoremap <C-x><C-p> cd '<C-w>"=expand('#:p:h')<CR>'<CR>| " Navigate to previows buffer directory
tnoremap <C-x>" <C-w>"| " Paste register
tnoremap <C-x>' <C-w>"*| " Paste clipboard
tnoremap <C-x>v vim --servername <C-w>"=v:servername<CR> --remote | " Write Vim's servername so you can open files on the current instance (you must append filename at the end)

tnoremap <C-\><C-\> <C-\><C-N><C-W>w
nnoremap <C-\><C-\> <cmd>call <sid>SwitchToalWindow()<CR>

function! <sid>SwitchToalWindow()
	if &buftype ==# 'al'
		wincmd p
		return
	endif
	for info in getwininfo()
		if getbufvar(info.bufnr, '&buftype') ==# 'al'
			let tabnr_winnr = win_id2tabwin(info.winid)
			exe tabnr_winnr[0] .. 'tabnext'
			exe tabnr_winnr[1] .. 'wincmd w'
			call feedkeys("\<C-\>\<C-n>")
			return
		endif
	endfor
	echomsg "No alternate window found."
endfunction

" Instead of single quotes, you could use =fnamemodify(getcwd(),":p:h:S") respectively =expand("#:p:h:S") to escape the path independt of the current shell.
"
" I will also give
"
" =trim(substitute(substitute(@0,''\r\?\n$'','''',''''),''\n'','' \\\r'',''g''))
" instead of "" a try in case the current register contains line breaks (similarly for "*/+).
