local function lsp_add_keymaps(bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)

  vim.keymap.set("n", "<leader>,", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, bufopts)

  vim.keymap.set("n", "<leader>vr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>vs", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>vd", require("telescope.builtin").diagnostics, bufopts)

  vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, bufopts)

  -- vim.keymap.set('n', '<leader>vws', require("telescope.builtin").lsp_workspace_symbols, bufopts)
  -- vim.keymap.set('n', '<leader>vds', require("telescope.builtin").lsp_document_symbols, bufopts)

  vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next, bufopts)
  vim.keymap.set("n", "<leader>p", vim.diagnostic.goto_prev, bufopts)
end

local function lsp_on_attach(client, bufnr)
  local cap = client.server_capabilities

  lsp_add_keymaps(bufnr)

  if client.supports_method "textDocument/formatting" then
    local group = vim.api.nvim_create_augroup("auto-formatting", { clear = false })

    vim.api.nvim_clear_autocmds {
      buffer = bufnr,
      group = group,
    }

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format {
          filter = function(c)
            local order = {
              "rust_analyzer",
              "clangd",
              "dartls",

              "null-ls",
            }

            for _, value in ipairs(order) do
              if c.name == value then return true end
            end

            return false
          end,
          bufnr = bufnr,
        }
      end,
    })
  end

  if cap.document_highlight then
    local group = vim.api.nvim_create_augroup("highlight", { clear = false })

    vim.api.nvim_clear_autocmds {
      buffer = bufnr,
      group = group,
    }

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
end

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
  },
  automatic_installation = true,
}

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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

require("lspconfig").clangd.setup {
  on_attach = lsp_on_attach,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--query-driver=/opt/homebrew/bin/arm-none-eabi-gcc,/opt/homebrew/bin/arm-none-eabi-g++",
  },
}

-- require("lspconfig").dartls.setup({
-- 	on_attach = lsp_on_attach,
-- 	capabilities = capabilities,
-- })

require("flutter-tools").setup {
  lsp = {
    on_attach = lsp_on_attach,
    capabilities = capabilities,
    settings = {
      enableSnippets = true,
    },
  },
}

require("lspconfig").lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
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

-- require("lspconfig").zls.setup({
-- 	on_attach = lsp_on_attach,
-- 	capabilities = capabilities,
-- })

require("lspconfig").tailwindcss.setup {
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

require("lspconfig").emmet_ls.setup {
  on_attach = lsp_on_attach,
  capabilities = capabilities,
  filetypes = {
    "html",
    "typescriptreact",
    "javascriptreact",
    "css",
    "sass",
    "scss",
    "less",
    "eruby",
    "vue",
    "svelte",
  },
}

require("lspconfig").volar.setup {
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

require("lspconfig").tsserver.setup {
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

require("lspconfig").svelte.setup {
  on_attach = lsp_on_attach,
  capabilities = capabilities,
}

-- require("lspconfig").nimls.setup {
--   on_attach = lsp_on_attach,
--   capabilities = capabilities,
-- }

-- require('lspconfig').gdscript.setup{
--     on_attach = on_attach,
--     capabilities = capabilities,
--     flags = {
--         debounce_text_changes = 150,
--     }
-- }

local null_ls = require "null-ls"

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier.with {
      filetypes = {
        "svelte",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "markdown.mdx",
        "graphql",
        "handlebars",
      },
    },

    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
  },
  on_attach = lsp_on_attach,
}
