" Author:  cocopon <cocopon@me.com>
" License: MIT License


let s:save_cpo = &cpo
set cpo&vim


" Init {{{
function! s:init()
	let defaults = {
				\ 	'g:po_mini_date_format': '%Y-%m-%d %H:%M%z',
				\ 	'g:po_mini_scan_lines': 20,
				\ }

	for name in keys(defaults)
		if !exists(name)
			execute printf('let %s = %s',
						\ name,
						\ string(defaults[name]))
		endif
	endfor
endfunction
call s:init()
" }}}


" Global {{{
function! po_mini#disable_auto_update()
	let b:po_mini_disable_auto_update = 1
endfunction


function! po_mini#update_date()
	let now = s:date()
	call s:update_entry('PO-Revision-Date', now)
endfunction


function! po_mini#update_all()
	call po_mini#update_date()

	if exists('g:po_mini_translator_name')
				\ && exists('g:po_mini_translator_email')
		let translator = s:account(
					\ g:po_mini_translator_name,
					\ g:po_mini_translator_email)
		call s:update_entry('Last-Translator', translator)
	endif

	if exists('g:po_mini_language_team_name')
				\ && exists('g:po_mini_language_team_email')
		let team = s:account(
					\ g:po_mini_language_team_name,
					\ g:po_mini_language_team_email)
		call s:update_entry('Language-Team', team)
	endif
endfunction


function! po_mini#bufwritepre()
	if get(g:, 'po_mini_disable_auto_update', 0)
				\ || get(b:, 'po_mini_disable_auto_update', 0)
		return
	endif

	call po_mini#update_all()
endfunction
" }}}


" Local {{{
function! s:find_entry(name)
	let lnum = 1
	while lnum <= g:po_mini_scan_lines
		let line = getline(lnum)

		if stridx(line, '"' . a:name . ':') == 0
			return lnum
		endif

		let lnum += 1
	endwhile

	return -1
endfunction


function! s:entry(name, value)
	return printf('"%s: %s\n"', a:name, a:value)
endfunction


function! s:date()
	return strftime(g:po_mini_date_format)
endfunction


function! s:account(name, email)
	return printf('%s <%s>', a:name, a:email)
endfunction


function! s:update_entry(name, value)
	let lnum = s:find_entry(a:name)
	if lnum < 0
		return 0
	endif

	call setline(lnum, s:entry(a:name, a:value))

	return 1
endfunction
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
