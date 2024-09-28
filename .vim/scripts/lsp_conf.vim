vim9script

var lsp_conf: dict<any> = {
	\ 'default': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'typescript': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'javascript': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'lua': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'python': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'rust': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'go': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'c': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'cpp': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'java': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'keywordprg': ':LspHover',
	\ }
\}

# Function to set the LSP options for the current filetype, with a fallback
def SetLspOptions()
	var filetype = &filetype
	var opts = get(lsp_conf, filetype, lsp_conf.default)

	if opts.keywordprg != ''
		execute 'setlocal! keywordprg=' .. opts.keywordprg
	endif

	if opts.gdprg != ''
		execute 'nmap <buffer> gd ' .. opts.gdprg
	endif
enddef

command! LspStart call lsp#enable()

# Use an autocommand group to apply the function for any filetype
augroup lsp_conf
	autocmd!
	autocmd User lsp_buffer_enabled call SetLspOptions()
	autocmd User lsp_buffer_enabled execute 'LspStart'
	autocmd User lsp_buffer_enabled call lsp#internal#inlay_hints#_enable()
augroup END
