require("tokyonight").setup {
  style = "storm",
}

vim.cmd [[colorscheme tokyonight]]

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

vim.opt.updatetime = 400
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.termguicolors = true

vim.g.mapleader = " "

require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
  },
}

local telescope = require "telescope"

telescope.setup {
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    prompt_prefix = " > ",
    color_devicons = true,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
}

telescope.load_extension "fzy_native"

local cmp = require "cmp"
local ls = require "luasnip"

cmp.setup {
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),

    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.complete {},
      c = function(
        _ --[[fallback]]
      )
        if cmp.visible() then
          if not cmp.confirm { select = true } then return end
        else
          cmp.complete()
        end
      end,
    },

    -- Testing
    ["<C-q>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "buffer", keyword_length = 3 },
  },

  snippet = {
    expand = function(args) ls.lsp_expand(args.body) end,
  },

  experimental = {
    ghost_text = true,
  },
}

require("mason").setup()

require("lualine").setup {}
-- require("nvim_comment").setup {}
require('Comment').setup()
require("todo-comments").setup {
  highlight = {
    before = "", -- "fg" or "bg" or empty
    keyword = "bg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)(\([^\)]*\))?:]],
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {}, -- list of file types to exclude highlighting
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
  },
}
require("trouble").setup {}

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>hh", "<cmd>Telescope help_tags<CR>")
vim.keymap.set("n", "<leader>e", function() 
  require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
end)

vim.keymap.set("n", "<leader>-", "<C-W>s");
vim.keymap.set("n", "<leader>|", "<C-W>v");
vim.keymap.set("n", "<C-h>", "<C-w>h");
vim.keymap.set("n", "<C-j>", "<C-w>j");
vim.keymap.set("n", "<C-k>", "<C-w>k");
vim.keymap.set("n", "<C-l>", "<C-w>l");

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")


local group = vim.api.nvim_create_augroup("gup", {
  clear = true
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group = group,
  pattern = {"*.nix"},
  callback = function(ev)
    vim.api.nvim_buf_set_option(ev.buf, "commentstring", "# %s")
    -- print(string.format('event fired: %s', vim.inspect(ev)))
  end
})

local function lsp_add_keymaps(bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)

  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, bufopts)
  vim.keymap.set("v", "f", vim.lsp.buf.format, bufopts)

  vim.keymap.set("n", "<leader>vr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>vs", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>vd", require("telescope.builtin").diagnostics, bufopts)
end

local function lsp_on_attach(client, bufnr)
  local cap = client.server_capabilities

  lsp_add_keymaps(bufnr)
end

-- local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").rust_analyzer.setup {
  on_attach = lsp_on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        allTargets = false,
      },
    },
  },
}

require('lspconfig').tsserver.setup{
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

require('lspconfig').gopls.setup{
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

require('lspconfig').svelte.setup{
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

require'lspconfig'.emmet_language_server.setup{
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

require'lspconfig'.tailwindcss.setup{
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier
  },
})

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank { timeout = 250 } end,
  group = highlight_group,
  pattern = "*",
})

local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

-- stylua: ignore
ls.add_snippets("toml", {
  s("rust", fmt([[
  unstable_features = true
  max_width = 79
  reorder_imports = true
  binop_separator = "Back"
  format_strings = true
  hex_literal_case = "Lower"
  imports_granularity = "Module"
  group_imports = "StdExternalCrate"
  ]], {}))
})

require("nvim-surround").setup({
})
