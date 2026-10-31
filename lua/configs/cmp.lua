local M = {}

function M.after_setup()
  local cmp = require "cmp"

  -- LaTeX: vimtex commands/cites + texlab LSP
  cmp.setup.filetype({ "tex", "plaintex", "latex" }, {
    sources = cmp.config.sources({
      { name = "vimtex", group_index = 1 },
      { name = "nvim_lsp", group_index = 1 },
      { name = "luasnip", group_index = 1 },
      { name = "buffer", group_index = 2 },
      { name = "async_path", group_index = 2 },
    }),
  })

  -- C3: LSP + snippets
  cmp.setup.filetype("c3", {
    sources = cmp.config.sources({
      { name = "nvim_lsp", group_index = 1 },
      { name = "luasnip", group_index = 1 },
      { name = "buffer", group_index = 2 },
      { name = "async_path", group_index = 2 },
    }),
  })

  -- ARM assembly: asm-lsp completions
  cmp.setup.filetype("asm", {
    sources = cmp.config.sources({
      { name = "nvim_lsp", group_index = 1 },
      { name = "luasnip", group_index = 1 },
      { name = "buffer", group_index = 2 },
      { name = "async_path", group_index = 2 },
    }),
  })
end

setmetatable(M, {
  __call = function()
    return require "nvchad.configs.cmp"
  end,
})

return M
