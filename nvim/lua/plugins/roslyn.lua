return {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
        -- your configuration comes here; leave empty for default settings
        settings = {
            ["csharp.inlayHints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
            },
            ["csharp.completion"] = {
                addImport = { allowReferences = true },
            },
            ["dotnet.completion"] = {
                provideSuggestionSupport = true,
            }
        },
    },
}
