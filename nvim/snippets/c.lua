---@diagnostic disable: undefined-global

return {
    s("main", {
        t("int main("), i(1), t({ ") {", "" }),
        t("    "),
        i(2),
        t({ "", "    return 0;" }),
        t({ "", "}" }),
        i(0),
    }),

    s({ trig = "def[a-z]*", regTrig = true }, {
        t("#define "), i(1, "BAUKLOTZ"), i(0)
    }),

    -- ifndef guard
    s({ trig = "ifn[a-z]*", regTrig = true }, {
        t("#ifndef "), i(1, "HEADER_H"), t({ "", "#define " }), rep(1),
        t({ "", "", "" }),
        i(2),
        t({ "", "", "#endif // " }), rep(1),
        i(0),
    }),

    -- include <>
    s({ trig = "inc[a-z]*", regTrig = true }, {
        t("#include <"), i(1, "stdio.h"), t(">"),
        i(0),
    }),

    -- include ""
    s({ trig = "inq[a-z]*", regTrig = true }, {
        t('#include "'), i(1, "header.h"), t('"'),
        i(0),
    }),

    -- struct
    s({ trig = "str[a-z]*", regTrig = true }, {
        t("struct "), i(1, "Name"), t({ " {", "    " }),
        i(2, "int field;"),
        t({ "", "};" }),
        i(0),
    }),

    -- typedef struct
    s({ trig = "tstr[a-z]*", regTrig = true }, {
        t("typedef struct {"), t({ "", "    " }),
        i(1, "int field;"),
        t({ "", "} " }), i(2, "Name"), t(";"),
        i(0),
    }),

    -- for loop
    s({ trig = "fo[a-z]*", regTrig = true }, {
        t("for ("), i(1, "int i = 0"), t("; "), i(2, "i < n"), t("; "), i(3, "i++"), t({ ") {", "" }),
        t("    "), i(4),
        t({ "", "}" }),
        i(0),
    }),

    -- while loop
    s({ trig = "wh[a-z]*", regTrig = true }, {
        t("while ("), i(1, "condition"), t({ ") {", "" }),
        t("    "), i(2),
        t({ "", "}" }),
        i(0),
    }),

    -- printf
    s({ trig = "pf[a-z]*", regTrig = true }, {
        t('printf("'), i(1, "%d\\n"), t('", '), i(2, "val"), t(");"),
        i(0),
    }),
}
