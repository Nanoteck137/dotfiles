require("plugins")

vim.cmd("colorscheme onedark")

vim.o.clipboard = "unnamedplus"
vim.o.syntax = "on"

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.guicursor = true
vim.o.hidden = true
vim.o.relativenumber = true
vim.o.nu = true
vim.o.nohlsearch = true
vim.o.noerrorbells = true
vim.o.incsearch = true
vim.o.scrolloff = 8
vim.o.colorcolumn = 80
vim.o.signcolumn = "yes"
vim.o.nowrap = true 
vim.o.cursorline = true
vim.o.mouse = "a"

vim.o.noswapfile = true
vim.o.nobackup = true

vim.g.mapleader = " "

require('nvim-treesitter.configs').setup({ 
    highlight = { 
        enable = true 
    } 
})

-- NOTE(patrik): Install "ripgrep (rg), fzy"
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' > ',
        color_devicons = true,
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}

require('telescope').load_extension('fzy_native')
