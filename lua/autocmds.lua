require "nvchad.autocmds"

-- Show LSP diagnostics while typing (default is only after leaving insert)
vim.diagnostic.config { update_in_insert = true }

-- rust-analyzer's cargo check only runs on save. Autosave Rust buffers after a
-- short idle so diagnostics refresh as you type, similar to clangd.
local rust_save_timer ---@type uv.uv_timer_t|nil

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = "*.rs",
  callback = function(args)
    if not vim.bo[args.buf].modifiable or not vim.bo[args.buf].modified then
      return
    end
    if vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end

    if rust_save_timer then
      rust_save_timer:stop()
      rust_save_timer:close()
    end

    rust_save_timer = vim.uv.new_timer()
    rust_save_timer:start(750, 0, vim.schedule_wrap(function()
      if rust_save_timer then
        rust_save_timer:stop()
        rust_save_timer:close()
        rust_save_timer = nil
      end

      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      if vim.bo[args.buf].modified and vim.bo[args.buf].buftype == "" then
        vim.api.nvim_buf_call(args.buf, function()
          vim.cmd "silent! update"
        end)
      end
    end))
  end,
})
