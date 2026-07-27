local M = {}

function M.after_setup()
  local cmp = require "cmp"
  local nvchad_format = require("nvchad.cmp").formatting.format

  cmp.register_source("avr_asm", require "cmp.sources.avr")

  cmp.setup.filetype("asm", {
    formatting = {
      format = function(entry, item)
        local detail = item.detail
        item = nvchad_format(entry, item)
        if entry.source.name == "avr_asm" and detail then
          item.menu = detail
        end
        return item
      end,
    },
    sources = cmp.config.sources({
      { name = "avr_asm", group_index = 1 },
      { name = "luasnip", group_index = 1 },
      { name = "buffer", group_index = 2 },
      { name = "nvim_lua", group_index = 2 },
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
