---@diagnostic disable: undefined-global

return {
    -- IMPORTANT blockquote
    s({ trig = "!important", snippetType = "autosnippet" }, {
        t("> [!IMPORTANT]"),
        t({ "", "> " }),
        i(1)
    }),
    s({ trig = "!i[a-z]*", regTrig = true, }, {
        t("> [!IMPORTANT]"),
        t({ "", "> " }),
        i(1)
    }),


    -- TIP blockquote
    s({ trig = "!tip", snippetType = "autosnippet" }, {
        t("> [!TIP]"),
        t({ "", "> " }),
        i(1)
    }),
    s({ trig = "!t[a-z]*", regTrig = true }, {
        t("> [!TIP]"),
        t({ "", "> " }),
        i(1)
    }),

    -- WARNING blockquote
    s({ trig = "!warning", snippetType = "autosnippet" }, {
        t("> [!WARNING]"),
        t({ "", "> " }),
        i(1)
    }),
    s({ trig = "!w[a-z]*", regTrig = true }, {
        t("> [!WARNING]"),
        t({ "", "> " }),
        i(1)
    }),

    -- NOTE blockquote
    s({ trig = "!note", snippetType = "autosnippet" }, {
        t("> [!NOTE]"),
        t({ "", "> " }),
        i(1)
    }),
    s({ trig = "!n[a-z]*", regTrig = true }, {
        t("> [!NOTE]"),
        t({ "", "> " }),
        i(1)
    }),

    -- CAUTION blockquote
    s({ trig = "!caution", snippetType = "autosnippet" }, {
        t("> [!CAUTION]"),
        t({ "", "> " }),
        i(1)
    }),
    s({ trig = "!c[a-z]*", regTrig = true }, {
        t("> [!CAUTION]"),
        t({ "", "> " }),
        i(1)
    }),

    s({ trig = "``", snippetType = "autosnippet" }, {
        t("```"), i(1, ""), t({ "", "" }),
        i(2, ""),
        t({ "", "```" })
    })
}
