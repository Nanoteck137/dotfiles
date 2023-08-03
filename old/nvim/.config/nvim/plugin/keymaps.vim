fun! TrimWhitespaces()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup MY_GROUP
    autocmd!
    autocmd BufWritePre * :call TrimWhitespaces()
augroup END

