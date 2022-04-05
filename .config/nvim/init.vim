call plug#begin(stdpath('data') . '/plugged')

Plug 'joshdick/onedark.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'beyondmarc/hlsl.vim'
Plug 'calviken/vim-gdscript3'

call plug#end()

lua require('nvim-treesitter.configs').setup({ highlight = { enable = true } })

set clipboard=unnamedplus
colorscheme onedark
syntax on

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

set guicursor=
set hidden
set relativenumber
set nu
set nohlsearch
set noerrorbells
set incsearch
set scrolloff=8
set colorcolumn=80
set signcolumn=yes
set nowrap
set cursorline
set mouse=a

set noswapfile
set nobackup

" Testing stuff with syntax highligting
" syntax keyword cppType u32

lua << EOF
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' >',
        color_devicons = true,

        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')
EOF

let mapleader=" "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for: ") })<CR>
nnoremap <leader>pd :lua require('telescope.builtin').treesitter()<CR>
nnoremap <leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>

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

tnoremap <Esc> <C-\><C-n>

function! TabOrComplete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=TabOrComplete()<CR>

fun! TrimWhitespaces()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup MY_GROUP
    autocmd!
    autocmd BufWritePre * :call TrimWhitespaces()
augroup END
