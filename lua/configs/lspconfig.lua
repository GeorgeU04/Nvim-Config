require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "clangd",
  "pyright",
  "rust_analyzer",
  "texlab",
  "jdtls",
  "ts_ls",
  "asm_lsp",
}
vim.lsp.enable(servers)

-- AVR assembly via asm-lsp (GAS + avr-gcc). Requires: cargo install asm-lsp
-- Global defaults live in ~/.config/asm-lsp/.asm-lsp.toml
vim.lsp.config("asm_lsp", {
  filetypes = { "asm", "vmasm" },
})

-- read :h vim.lsp.config for changing options of lsp servers
