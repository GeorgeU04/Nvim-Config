require("nvchad.configs.lspconfig").defaults()

local nvchad_lsp = require "nvchad.configs.lspconfig"
local capabilities = vim.tbl_deep_extend(
  "force",
  nvchad_lsp.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)
vim.lsp.config("*", { capabilities = capabilities })

require("cmp_nvim_lsp").setup()

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

-- texlab: LaTeX LSP (command completion, diagnostics, build helpers)
vim.lsp.config("texlab", {
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-auxdir=build",
          "%f",
        },
        onSave = false,
      },
      forwardSearch = {
        executable = "okular",
        args = { "--unique", "%p" },
      },
      completion = {
        matcher = "fuzzy-ignore-case",
      },
    },
  },
})

-- rust-analyzer: full cargo diagnostics normally only run on save (unlike clangd).
-- Experimental diagnostics + autosave-on-idle make errors appear while editing.
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,
      diagnostics = {
        enable = true,
        experimental = {
          enable = true,
        },
      },
    },
  },
})

-- AVR assembly via asm-lsp (GAS + avr-gcc). Requires: cargo install asm-lsp
-- Global defaults live in ~/.config/asm-lsp/.asm-lsp.toml
vim.lsp.config("asm_lsp", {
  filetypes = { "asm", "vmasm" },
  workspace_required = false,
  root_dir = function(bufnr, on_dir)
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then
      on_dir(nil)
      return
    end
    on_dir(vim.fs.root(path, { ".asm-lsp.toml", ".git" }) or vim.fs.dirname(path))
  end,
})

-- read :h vim.lsp.config for changing options of lsp servers
