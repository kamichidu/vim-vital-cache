let s:suite= themis#suite('Cache')
let s:assert= themis#helper('assert')

let s:cache_file= '$TEMP/vim-vital-cache'

function! s:suite.before_each()
    let s:C= vital#of('vital').import('Cache')
endfunction

function! s:suite.after_each()
    unlet! s:C
endfunction
