nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for: ") })<CR>
nnoremap <leader>pd :lua require('telescope.builtin').treesitter()<CR>
nnoremap <leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>

nnoremap <leader>ta :lua require('telescope.builtin').tags()<CR>
nnoremap <leader>td <C-]>
nnoremap <leader>tt <C-t>

nnoremap <leader>hh :lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>ho :lua require('telescope.builtin').vim_options()<CR>

nnoremap <leader>wj <C-w><C-j>
nnoremap <leader>wk <C-w><C-k>
nnoremap <leader>wl <C-w><C-l>
nnoremap <leader>wh <C-w><C-h>
nnoremap <leader>wt <C-^>
nnoremap <leader>wsv :vsp<CR>
nnoremap <leader>wsh :sp<CR>

nnoremap <leader>qo :copen<CR>
nnoremap <leader>qn :cnext<CR>
nnoremap <leader>qp :cprev<CR>

noremap <C-j> <M-}>
noremap <C-k> <M-{>

tnoremap <leader><Esc> <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n>

" Move line(s) up and down
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi

function! TabOrComplete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=TabOrComplete()<CR>
