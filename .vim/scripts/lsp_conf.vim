vim9script

if executable('ruff')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'ruff',
				\ 'cmd': ['ruff', 'server'],
				\ 'allowlist': ['python'],
				\ })
endif

function On_lsp_buffer_enabled() abort
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	if exists('+omnifunc') | setlocal omnifunc=lsp#complete | endif

	nmap <buffer> <silent> gd <plug>(lsp-definition)
	nmap <buffer> <silent> gD <plug>(lsp-type-definition)
	nmap <buffer> <silent> K  <plug>(lsp-hover)
	nmap <buffer> <silent> <leader>gr <plug>(lsp-rename)
	nmap <buffer> gn <plug>(lsp-previous-diagnostic)
	nmap <buffer> gp <plug>(lsp-next-diagnostic)

	let b:lsp_format_sync = get(b:, 'lsp_format_sync', v:true)
	let b:lsp_format_on_save = get(b:, 'lsp_format_on_save', v:false)

	let l:capabilities = lsp#get_server_capabilities('ruff')
	if !empty(l:capabilities)
		let l:capabilities.hoverProvider = v:false
	endif
endfunction

augroup lsp_conf
	autocmd!
	autocmd FileType * call On_lsp_buffer_enabled()
augroup END
