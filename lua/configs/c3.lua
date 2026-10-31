-- C3 language support (c3c + c3lsp + tree-sitter)

vim.filetype.add {
  extension = {
    c3 = "c3",
    c3i = "c3",
    c3t = "c3",
  },
}

vim.treesitter.language.register("c3", { "c3" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c3",
  callback = function()
    vim.bo.commentstring = "// %s"
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

-- nvim-web-devicons has no built-in C3 icon; register a custom one
vim.schedule(function()
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    return
  end

  local c3_icon = {
    icon = "",
    color = "#5CC8A2",
    cterm_color = "79",
    name = "C3",
  }

  devicons.set_icon {
    c3 = c3_icon,
    c3i = vim.tbl_extend("force", c3_icon, { name = "C3Interface" }),
    c3t = vim.tbl_extend("force", c3_icon, { name = "C3Template" }),
  }

  -- Map filetype -> icon name for statusline / bufferline lookups by ft
  pcall(devicons.set_icon_by_filetype, { c3 = "c3" })
end)
