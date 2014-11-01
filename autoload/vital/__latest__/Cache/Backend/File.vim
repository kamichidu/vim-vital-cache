let s:save_cpo= &cpo
set cpo&vim

function! s:_vital_loaded(V)
endfunction

function! s:_vital_depends()
    return []
endfunction

function! s:get(config, key)
    let data= s:_read(a:config)
    if has_key(data, a:key)
        return data[a:key]
    else
        throw printf("vital: Cache.Backend.File: No such key `%s'.", a:key)
    endif
endfunction

function! s:put(config, key, value)
    let data= s:_read(a:config)
    let data[a:key]= a:value
    call s:_write(a:config, data)
endfunction

function! s:has(config, key)
    let data= s:_read(a:config)
    return has_key(data, a:key)
endfunction

function! s:remove(config, key)
    let data= s:_read(a:config)
    if has_key(data, a:key)
        call remove(data, a:key)
    endif
    call s:_write(a:config, data)
endfunction

function! s:remove_all(config)
    call s:_write(a:config, {})
endfunction

function! s:_read(config)
    if !has_key(a:config, 'filename')
        throw "vital: Cache.Backend.File: Missing configuration `filename'."
    endif

    if filereadable(a:config.filename)
        return eval(join(readfile(a:config.filename), ''))
    else
        return {}
    endif
endfunction

function! s:_write(config, data)
    call writefile([string(a:data)], a:config.filename)
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
