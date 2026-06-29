local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black", "isort" },
    java = { "google-java-format" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
  },
}

return options
