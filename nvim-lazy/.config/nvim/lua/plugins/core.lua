return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "rust-analyzer",
      },
    },
  },

  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")

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
    end,
  },
}
