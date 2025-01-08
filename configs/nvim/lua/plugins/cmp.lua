local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

luasnip.filetype_extend("htmldjango", {"html"});
luasnip.filetype_extend("templ", {"html"});

---@diagnostic disable-next-line: missing-fields
cmp.setup {
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),

    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.complete {},
      c = function()
        if cmp.visible() then
          if not cmp.confirm { select = true } then return end
        else
          cmp.complete()
        end
      end,
    },
  },

  sources = {
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "buffer" },
  },

  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },

  experimental = {
    ghost_text = true,
  },
}
