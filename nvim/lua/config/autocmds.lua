
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.h",
  callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in ipairs(lines) do
      if line:match("class ") or line:match("namespace ") or line:match("template ") then
        vim.bo.filetype = "cpp"
        return
      end
    end
    vim.bo.filetype = "c"
  end,
})
