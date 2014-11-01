let s:suite= themis#suite('Cache')
let s:assert= themis#helper('assert')

function! s:suite.before_each()
    let s:C= vital#of('vital').import('Cache')
endfunction

function! s:suite.after_each()
    unlet! s:C
endfunction

function! s:suite.basic_usage()
    let cache= s:C.new('file', {'filename': './cache'})

    let data= cache.get('list', '[1, 2, 3]')
    call s:assert.same(data, [1, 2, 3])
endfunction
