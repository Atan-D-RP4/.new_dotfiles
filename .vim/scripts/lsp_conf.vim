vim9script

var lsp_conf: dict<any> = {
	\ 'default': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'typescript': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'javascript': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'lua': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'python': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'rust': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'go': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'c': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'cpp': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ },
	\ 'java': {
		\ 'gdprg': '<plug>(lsp-definition)',
		\ 'omnifunc': 'lsp#complete',
		\ 'keywordprg': ':LspHover',
	\ }
\}

# Function to set the LSP options for the current filetype, with a fallback
def SetLspOptions()
	var filetype = &filetype
	var opts = get(lsp_conf, filetype, lsp_conf.default)

	if opts.omnifunc != ''
		execute 'setlocal! omnifunc=' .. opts.omnifunc
	endif

	if opts.keywordprg != ''
		execute 'setlocal! keywordprg=' .. opts.keywordprg
	endif

	if opts.gdprg != ''
		execute 'nmap <buffer> gd ' .. opts.gdprg
	endif
enddef

# Use an autocommand group to apply the function for any filetype
augroup lsp_conf
	autocmd!
	autocmd User lsp_buffer_enabled call SetLspOptions()
augroup END
