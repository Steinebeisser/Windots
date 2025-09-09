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
}
