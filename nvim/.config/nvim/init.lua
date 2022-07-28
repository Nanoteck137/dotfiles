require("plugins")
require("globals")

-- TODO(patrik): Explore tabs inside nvim
-- TODO(patrik): Explore quickfix list

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

vim.opt.updatetime = 400

vim.g.mapleader = " "

require('lspconfig').rust_analyzer.setup {
    on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

        -- NOTE(patrik): Maybe? vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, bufopts)

        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)

        vim.keymap.set('n', '<leader>vr', vim.lsp.buf.references, bufopts)

        vim.keymap.set('n', '<leader>vs', vim.lsp.buf.signature_help, bufopts)

        vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, bufopts)

        vim.keymap.set('n', '<leader>vws', require("telescope.builtin").lsp_workspace_symbols, bufopts)
        vim.keymap.set('n', '<leader>vds', require("telescope.builtin").lsp_document_symbols, bufopts)

        -- USE: format({options})

        vim.keymap.set('n', '<leader>hs', vim.lsp.buf.document_highlight, bufopts)
        vim.keymap.set('n', '<leader>hc', vim.lsp.buf.clear_references, bufopts)

        local group = vim.api.nvim_create_augroup("testing", { clear = false })

        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = group,
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            pattern = "<buffer>",
            callback = function()
                vim.lsp.buf.format()
            end,
        })

        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("CursorMovedI", {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references,
        })
    end
}

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

local cmp = require("cmp")
local ls = require("luasnip")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
    mapping = {
        -- Maybe switch to not using tab
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif ls.expand_or_jumpable() then
            ls.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif ls.jumpable(-1) then
            ls.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
    },

    sources = {
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer", keyword_length = 5 },
    },

    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body)
        end
    },

    experimental = {
        ghost_text = true,
    },
}

require('lualine').setup {
  -- Using winbar is little buggy with lualine for now
}

require('Comment').setup {}

vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/plugin/luasnip.lua<CR>");
