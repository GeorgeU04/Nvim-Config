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

-- pyright: use project venv / $VIRTUAL_ENV so installed packages resolve
local function find_python(root)
  if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
    local candidate = vim.env.VIRTUAL_ENV .. "/bin/python"
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  if not root or root == "" then
    return nil
  end

  for _, name in ipairs { ".venv", "venv", "env" } do
    local candidate = root .. "/" .. name .. "/bin/python"
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end

  return nil
end

vim.lsp.config("pyright", {
  before_init = function(_, config)
    local python = find_python(config.root_dir)
    if not python then
      return
    end

    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      python = {
        pythonPath = python,
      },
    })
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
})

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
