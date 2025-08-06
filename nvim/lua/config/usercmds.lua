vim.api.nvim_create_user_command("OpenHTML", function()
  vim.cmd("TOhtml")
  vim.ui.open(vim.fn.expand("%"))
end, {})

vim.api.nvim_create_user_command("Http", function()
  vim.cmd("args src/**/*.c src/**/*.h | argdo edit")
end, {})
