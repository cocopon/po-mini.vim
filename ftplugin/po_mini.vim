" Author:  cocopon <cocopon@me.com>
" License: MIT License


if exists('b:did_ftplugin')
	finish
endif


let s:save_cpo = &cpo
set cpo&vim


autocmd BufWritePre <buffer> call po_mini#bufwritepre()
let b:undo_ftplugin = ''


let &cpo = s:save_cpo
unlet s:save_cpo
