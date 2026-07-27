-- AVR assembly (ATmega328P) support for avr-gcc / GNU as (.S / .s files)

vim.filetype.add {
  extension = {
    S = "asm",
    s = "asm",
    asm = "asm",
  },
}

vim.treesitter.language.register("asm", { "asm" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "asm",
  callback = function()
    vim.bo.commentstring = "// %s"
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})
