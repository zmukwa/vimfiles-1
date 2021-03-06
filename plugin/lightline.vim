" Settings for Lightline
" ----------------------

let g:lightline = {
			\ 'colorscheme' : 'wombat',
			\ 'active': {
			\   'left': [ [ 'mode', 'paste' ],
			\             [ 'gitbranch', 'filename' ],
			\             [ 'modified', 'readonly' ] ],
			\   'right': [['lineinfo'], ['percent'], 
			\             ['fileencoding', 'filetype']]
			\ },
			\ 'component_function': {
			\   'gitbranch': 'fugitive#head',
			\   'modified': 'lightline#mod',
			\   'readonly': 'lightline#readonly',
			\   'filename': 'lightline#name',
			\   'fileformat': 'lightline#fileformat',
			\   'filetype': 'lightline#filetype',
			\   'fileencoding': 'lightline#encoding',
			\ },
			\ 'component_type': {
			\		'readonly': 'error',
			\ },
			\ }

" Custom functions for lightline.vim
" These were adapted from http://code.xero.nu/dotfiles
function lightline#mod()
	return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : ''
endfunction

function lightline#readonly()
	return &ft !~? 'help\|vimfiler' && &readonly ? 'RO' : ''
endfunction

" This function will return the path of the file compressed to show only the
" first character for all preceding directories except the last
function lightline#name() abort
	
	" if exists('b:cached_filename') && len(b:cached_filename) > 0
	" 	return b:cached_filename
	" endif

	if &filetype ==# 'nerdtree'
		let b:cached_filename = '[Filesystem]'
	elseif expand('%:t') ==? ''
		let b:cached_filename = '[None]'
	elseif &filetype == 'help'
		" Don't do path reduction on help files
		let b:cached_filename = expand('%:t')
	else
		" Reduce path to ~/.x/x/x/x/directory/filename.ext
		let l:path = split(expand('%:~:.'), '\/')
		let l:i = 0
		while l:i < len(l:path) - 2
			let l:firstchar = strpart(l:path[l:i], 0, 1)
			if l:firstchar == '.'
				let l:path[l:i] = strpart(l:path[l:i], 0, 2)
			else 
				let l:path[l:i] = l:firstchar
			endif
			let l:i = l:i + 1
		endwhile
		let b:cached_filename = join(l:path, '/')
	endif

	if exists('b:fugitive_type') && b:fugitive_type ==# 'blob'
		let b:cached_filename .= ' (blob)'
	endif
	
	return b:cached_filename
endfunction

" augroup lightline-cache
" 	autocmd!
" 	autocmd DirChanged,WinEnter *
" 		\ unlet! b:cached_filename
" augroup END

" function lightline#getcwd() abort
" 	let dir = getbufvar('%', 'current_dir')
" 	let g:curr_dir = getcwd()
" 	if empty(dir) || dir != g:curr_dir
" 		call setbufvar('%', 'current_dir', g:curr_dir)
" 		unlet! b:cached_filename
" 	endif
" 	return fnamemodify(dir, ':t')
" endfunction

function lightline#fileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function lightline#filetype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : '') : ''
endfunction

function lightline#encoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &enc : &enc) : ''
endfunction

" TODO
" Come up with a LightlineMode function that will replace the
" NORMAL/INSERT/VISUAL mode text with plugin-specific things. From a quick
" glance through the source to Lightline, it looks a bit beyond my abilities
" right now

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
	if exists('#lightline')
		call lightline#update()
	end
endfunction
