local ls = require("luasnip")

ls.config.set_config {
    histroy = true,

    updateevents = "TextChanged,TextChangedI",

    enable_autosnippets = true,
}

ls.add_snippets("rust", {
    ls.parser.parse_snippet("for", "for $1 {\n    $0\n}"),
    ls.parser.parse_snippet("pl", "println!(\"$0\");"),
})

ls.add_snippets("toml", {
    -- TODO(patrik): Add rustfmt content
    ls.parser.parse_snippet("rust", "println!(\"$0\");"),
})
