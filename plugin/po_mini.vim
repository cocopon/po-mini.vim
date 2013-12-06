" Author:  cocopon <cocopon@me.com>
" License: MIT License


let s:save_cpo = &cpo
set cpo&vim


command! -nargs=0 PoMiniDisableAutoUpdate call po_mini#disable_auto_update()
command! -nargs=0 PoMiniUpdate call po_mini#update_all()
command! -nargs=0 PoMiniUpdateRevisionDate call po_mini#update_date()


let &cpo = s:save_cpo
unlet s:save_cpo
