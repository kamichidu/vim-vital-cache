let s:save_cpo= &cpo
set cpo&vim

function! s:_vital_loaded(V)
    let s:Closure= a:V.import('Data.Closure')

    let s:backends= {}
    for backend in a:V.search('Cache.Backend.*')
        let s:backends[backend]= a:V.import(backend)
    endfor
endfunction

function! s:_vital_depends()
    return ['Cache.Backend.*', 'Data.Closure']
endfunction

let s:null_loader= {}

function! s:get(container, config, key, ...)
    let loader= get(a:000, 0, s:null_loader)

    if a:container.has(a:config, a:key)
        return a:container.get(a:config, a:key)
    else
        if loader is s:null_loader
            throw 'vital: Cache: {loader} is required!'
        elseif !s:Closure.is_callable(loader)
            throw 'vital: Cache: {loader} must be a {callable}.'
        endif
        call a:container.put(a:config, a:key, s:Closure.apply(loader, []))
        return a:container.get(a:config, a:key)
    endif
endfunction

function! s:remove(container, config, key, ...)
    for key in [a:key] + a:000
        call a:container.remove(a:config, key)
    endfor
endfunction

function! s:remove_all(container, config)
    call a:container.remove_all(a:config)
endfunction

let s:cache= {}

function! s:new(backend, ...)
    let module_name= 'Cache.Backend.' . s:_capitalize(a:backend)

    if !has_key(s:backends, module_name)
        throw printf("vital: Cache: No such backend module `%s'.", a:backend)
    endif

    let cache= deepcopy(s:cache)
    let cache.__backend= s:backends[module_name]
    let cache.__config= get(a:000, 0, {})
    return cache
endfunction

function! s:cache.get(key, ...)
    return call('s:get', [self.__backend, self.__config, a:key] + a:000)
endfunction

function! s:cache.remove(key, ...)
    call call('s:remove', [self.__backend, self.__config, a:key] + a:000)
endfunction

function! s:cache.remove_all()
    call call('s:remove_all', [self.__backend, self.__config])
endfunction

function! s:_capitalize(word)
    return substitute(a:word, '\%(^\|_\)\(\l\)', '\u\1', 'g')
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
