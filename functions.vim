"              __                            
"      __  __ /\_\    ___ ___   _ __   ___   
"     /\ \/\ \\/\ \ /' __` __`\/\`'__\/'___\ 
"   __\ \ \_/ |\ \ \/\ \/\ \/\ \ \ \//\ \__/ 
"  /\_\\ \___/  \ \_\ \_\ \_\ \_\ \_\\ \____\
"  \/_/ \/__/    \/_/\/_/\/_/\/_/\/_/ \/____/
"                                            
"                                            
" Author: Robbie Smith
" repo  : https://github.com/zoqaeski/vimfiles
"
""""""""""""""""""""""""""""""""""""""""
"
" Functions and Commands
"
" This section contains functions and commands that are required by other
" sections of my vimrc.
" 
""""""""""""""""""""""""""""""""""""""""

" Functions {{{
" ---------

function! EnsureExists(path) " {{{
	if !isdirectory(expand(a:path))
		call mkdir(expand(a:path))
	endif
endfunction " }}}

function! Cwd() " {{{
	let cwd = getcwd()
	return "e " . cwd 
endfunction " }}}

function! CurrentFileDir(cmd) " {{{
	return a:cmd . " " . expand("%:p:h") . "/"
endfunction " }}}

function! VisualSearch(direction) range " {{{		
	let l:saved_reg = @"
	execute "normal! vgvy"

	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")

	if a:direction == 'b'
		execute "normal ?" . l:pattern . "^M"
	elseif a:direction == 'f'
		execute "normal /" . l:pattern . "^M"
	endif

	let @/ = l:pattern
	let @" = l:saved_reg
endfunction " }}}

" Creates a temporary working buffer
function! ScratchEdit(cmd, options) " {{{
	exe a:cmd tempname()
	setl buftype=nofile bufhidden=wipe nobuflisted
	if !empty(a:options) | exe 'setl' a:options | endif
endfunction " }}}

" Identifies the syntax colouring item under the cursor
function! <SID>SynStack() " {{{
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc " }}}

" Useful Commands {{{
" ---------------

" Diff original file
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! Clear norm gg"_dG

" Scratch buffers
command! -bar -nargs=* Sedit call ScratchEdit('edit', <q-args>)
command! -bar -nargs=* Ssplit call ScratchEdit('split', <q-args>)
command! -bar -nargs=* Svsplit call ScratchEdit('vsplit', <q-args>)
command! -bar -nargs=* Stabedit call ScratchEdit('tabe', <q-args>)

" }}}

" vim: ft=vim fdm=marker ts=2 sts=2 sw=2 fdl=0 :
