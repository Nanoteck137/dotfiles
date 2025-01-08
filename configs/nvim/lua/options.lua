vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.clipboard = "unnamedplus"
vim.opt.syntax = "on"
vim.opt.laststatus = 3

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

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

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.termguicolors = true

vim.opt.undofile = true

vim.diagnostic.config {
  underline = {
    severity = vim.diagnostic.severity.ERROR,
  }
}

vim.cmd([[
set conceallevel=2
syn match NBSP '\%xa0' conceal cchar=␣
syn match NarrowNBSP '\%u202F' conceal cchar=⸤
]])
