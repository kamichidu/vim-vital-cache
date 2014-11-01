let s:suite= themis#suite('Cache.Backend.File')
let s:assert= themis#helper('assert')

let s:config= {'filename': expand('$TEMP/vim-vital-cache')}

function! s:suite.before_each()
    let s:C= vital#of('vital').import('Cache.Backend.File')
    if filereadable(s:config.filename)
        call delete(s:config.filename)
    endif
endfunction

function! s:suite.after_each()
    unlet! s:C
    if filereadable(s:config.filename)
        call delete(s:config.filename)
    endif
endfunction

function! s:suite.get()
    let data= {'hoge': 'fuga'}

    call writefile([string(data)], s:config.filename)

    call s:assert.same(s:C.get(s:config, 'hoge'), 'fuga')
endfunction

function! s:suite.put()
    call s:C.put(s:config, 'hoge', 'fuga')

    call s:assert.same(s:C.get(s:config, 'hoge'), 'fuga')
endfunction

function! s:suite.has()
    call s:assert.false(s:C.has(s:config, 'hoge'))
    call s:C.put(s:config, 'hoge', 'fuga')
    call s:assert.true(s:C.has(s:config, 'hoge'))
endfunction

function! s:suite.remove()
    call s:C.put(s:config, 'hoge', 'fuga')
    call s:assert.true(s:C.has(s:config, 'hoge'))
    call s:C.remove(s:config, 'hoge')
    call s:assert.false(s:C.has(s:config, 'hoge'))
endfunction

function! s:suite.remove_all()
    call s:C.put(s:config, 'hoge', 'fuga')
    call s:assert.true(s:C.has(s:config, 'hoge'))
    call s:C.remove_all(s:config)
    call s:assert.false(s:C.has(s:config, 'hoge'))
endfunction
