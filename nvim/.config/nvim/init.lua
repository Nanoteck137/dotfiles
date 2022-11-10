vim.notify = require("notify")

require("plugins")
require("globals")

-- TODO(patrik): Explore tabs inside nvim
-- TODO(patrik): Explore quickfix list
-- TODO(patrik): Explore focus
-- TODO(patrik): Add snippet for LICENCE

vim.g.tokyonight_style = "storm"
vim.cmd [[colorscheme tokyonight]]
vim.cmd [[highlight WinSeparator guifg=DarkGray]]
vim.cmd [[set winbar=%=%f\ %m%=]]

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
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.termguicolors = true

vim.g.mapleader = " "

local function lsp_on_attach(client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, bufopts)

    vim.keymap.set('n', '<leader>vr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>vs', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>vd', require("telescope.builtin").diagnostics, bufopts)

    vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, bufopts)

    -- vim.keymap.set('n', '<leader>vws', require("telescope.builtin").lsp_workspace_symbols, bufopts)
    -- vim.keymap.set('n', '<leader>vds', require("telescope.builtin").lsp_document_symbols, bufopts)

    vim.keymap.set('n', '<leader>n', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', '<leader>p', vim.diagnostic.goto_prev, bufopts)

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

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').rust_analyzer.setup {
    on_attach = lsp_on_attach,
    capabilities = capabilities
}

require('lspconfig').clangd.setup {
    on_attach = lsp_on_attach,
    capabilities = capabilities
}

require 'lspconfig'.sumneko_lua.setup {
    on_attach = lsp_on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- require('lspconfig').gdscript.setup{
--     on_attach = on_attach,
--     capabilities = capabilities,
--     flags = {
--         debounce_text_changes = 150,
--     }
-- }

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
require('telescope').load_extension('sobble')

local cmp = require("cmp")
local ls = require("luasnip")

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<c-y>"] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            },
            { "i", "c" }
        ),

        ["<c-space>"] = cmp.mapping {
            i = cmp.mapping.complete(),
            c = function(
            _ --[[fallback]]
            )
                if cmp.visible() then
                    if not cmp.confirm { select = true } then
                        return
                    end
                else
                    cmp.complete()
                end
            end,
        },

        -- ["<tab>"] = false,
        ["<tab>"] = cmp.config.disable,

        -- ["<tab>"] = cmp.mapping {
        --   i = cmp.config.disable,
        --   c = function(fallback)
        --     fallback()
        --   end,
        -- },

        -- Testing
        ["<c-q>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
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

require('lualine').setup {}
require('Comment').setup {}
require("focus").setup {}

require("dired").setup {
    path_separator = "/",
    show_banner = false,
    show_hidden = true
}

vim.keymap.set({ "i", "s" }, "<c-n>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-p>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)


local tb = require('telescope.builtin')

local function close_all_windows_in_current_tab()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local current_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(wins) do
        if win ~= current_win then
            vim.api.nvim_win_close(win, false)
        end
    end
end

-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/autoload/tj.vim
local function save_and_exec()
    local type = vim.bo.filetype
    if type == "lua" or type == "vim" then
        vim.cmd [[silent! write]]
        vim.cmd [[source %]]
    end
end

vim.keymap.set("n", "<leader>ps", function()
    local search = vim.fn.input("Grep for: ");
    tb.grep_string({ search = search })
end)

-- TODO(patrik):
-- Telescope current_buffer_fuzzy_find
-- Telescope command_history

vim.keymap.set("x", "<leader>pp", "\"_dP")

vim.keymap.set("n", "<leader>pd", tb.treesitter)
vim.keymap.set("n", "<leader>pf", tb.find_files)
vim.keymap.set("n", "<leader>pb", tb.buffers)

vim.keymap.set("n", "<leader>hh", tb.help_tags)
vim.keymap.set("n", "<leader>ho", tb.vim_options)

vim.keymap.set("n", "<leader>wj", "<C-w><C-j>")
vim.keymap.set("n", "<leader>wk", "<C-w><C-k>")
vim.keymap.set("n", "<leader>wl", "<C-w><C-l>")
vim.keymap.set("n", "<leader>wh", "<C-w><C-h>")
vim.keymap.set("n", "<leader>wp", "<C-w><C-p>")
vim.keymap.set("n", "<leader>wq", close_all_windows_in_current_tab)

vim.keymap.set("n", "<leader>wsv", "<cmd>vsp<CR>")
vim.keymap.set("n", "<leader>wsh", "<cmd>sp<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- vim.keymap.set({ "n", "v" }, "<C-j>", "<M-}>")
-- vim.keymap.set({ "n", "v" }, "<C-k>", "<M-{>")

vim.keymap.set("n", "<leader>tt", "<cmd>tab split<CR>")
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<CR>")
vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<CR>")
vim.keymap.set("n", "<leader>tml", "<cmd>tabmove +1<CR>")
vim.keymap.set("n", "<leader>tmh", "<cmd>tabmove -1<CR>")

vim.keymap.set("n", "<leader>xx", save_and_exec)
-- vim.keymap.set("n", "<leader>xs", "<cmd>source ~/.config/nvim/plugin/luasnip.lua<CR>");

-- TODO(patrik): Use quickfix
vim.keymap.set("n", "<leader>qq", "<cmd>copen<CR>")
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>")
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>")

vim.keymap.set('n', '<leader>gd', "<C-]>")
vim.keymap.set('n', '<leader>vds', tb.tags)
