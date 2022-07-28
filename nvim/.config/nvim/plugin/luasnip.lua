local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

ls.config.set_config {
    histroy = true,

    updateevents = "TextChanged,TextChangedI",
}

-- TODO(patrik): Add snippet for functions
ls.add_snippets("rust", {
    s("for", fmt([[
        for {} in {} {{
            {}
        }}
    ]], {
        i(1, ""),
        i(2, ""),
        i(3, "")
    })),

    s("p", fmt([[
        {}!("{}"{});
    ]], {
        c(1, {
            t "println",
            t "print",
        }),
        i(2, ""),
        i(3, ""),
    })),

    s("lf", fmt([[
        let {} = {}({});
    ]], {
        i(1, ""),
        i(2, ""),
        i(3, ""),
    })),

    s("if", fmt([[
        if {} {{
            {}
        }}
    ]], {
        c(1, {
            i(1, "cond"),

            sn(nil, fmt([[
                let Some({}) = {}
            ]], {
                i(1, "var"),
                i(2, "opt"),
            })),

            sn(nil, fmt([[
                let Ok({}) = {}
            ]], {
                i(1, "var"),
                i(2, "res"),
            })),
        }),
        i(2, ""),
    })),

    s("match", fmt([[
        match {} {{
            {}
        }}
    ]], {
        i(1, "cond"),
        c(2, {
            t "",
            t "_ => todo!(),",
        }),
    }))
})

ls.add_snippets("toml", {
    s("rust", fmt([[
        max_width = 79
        reorder_imports = false
        binop_separator = "Back"
        format_strings = true
        hex_literal_case = "Lower"
    ]], {}))
})

