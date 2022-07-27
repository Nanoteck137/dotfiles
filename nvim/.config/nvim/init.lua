require("plugins")

vim.g.tokyonight_style = "storm"
vim.cmd[[colorscheme tokyonight]]
vim.cmd[[highlight WinSeperator guifg=None]]
vim.cmd[[set winbar=%f]]

vim.opt.clipboard = "unnamedplus"
vim.opt.syntax = "on"
vim.opt.laststatus = 3

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.scrolloff = 8

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.belloff = "all"

vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"

vim.opt.guicursor = "n-v-c:"
vim.opt.cursorline = true
vim.opt.mouse = "a"

vim.opt.swapfile = false
vim.opt.backup = false

vim.g.mapleader = " "

require('lspconfig').rust_analyzer.setup {}

require('nvim-treesitter.configs').setup({ 
    highlight = { 
        enable = true 
    } 
})

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

require('lualine').setup {
  options = {
    theme = 'tokyonight'
  },

  -- Using winbar is little buggy with lualine for now
}

require('Comment').setup {}
