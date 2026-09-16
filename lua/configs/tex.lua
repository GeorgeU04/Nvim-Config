-- TeX / LaTeX filetype helpers (syntax via vimtex + treesitter latex)

vim.treesitter.language.register("latex", { "tex", "plaintex", "latex" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex", "latex" },
  callback = function()
    vim.bo.commentstring = "% %s"
    -- Prefer vimtex syntax for LaTeX commands/environments
    pcall(vim.cmd, "syntax enable")
  end,
})
