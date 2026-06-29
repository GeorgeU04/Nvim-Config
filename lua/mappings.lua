require "nvchad.mappings"

local map = vim.keymap.set

-- Command mode shortcut
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Exit insert mode
map("i", "jk", "<ESC>")

-- Close buffer, keeping window open and switching to another normal file buffer
map("n", "<leader>cb", function()
  local current_buf = vim.api.nvim_get_current_buf()

  if vim.bo[current_buf].modified then
    vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
    return
  end

  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_loaded(buf)
        and vim.bo[buf].buflisted
        and buf ~= current_buf
  end, vim.api.nvim_list_bufs())

  if #buffers > 0 then
    vim.api.nvim_set_current_buf(buffers[#buffers])
  else
    vim.cmd("enew")
  end

  vim.cmd("bdelete " .. current_buf)
end, { desc = "Close buffer, keep window" })

-- Ctrl+S to format and save
map({ "n", "i" }, "<C-s>", function()
  vim.lsp.buf.format({ async = true }) -- format the file
  vim.cmd("write")                     -- save the file
end, { desc = "Format & Save" })

-- Window navigation

-- Smart window navigation (with NvimTree support)
local function smart_nav(direction)
  local nvim_tree_api = require("nvim-tree.api")
  local tree_open = nvim_tree_api.tree.is_visible()

  if direction == "h" and tree_open then
    -- If moving left and NvimTree is open, focus it
    nvim_tree_api.tree.focus()
  else
    -- Otherwise, use normal window navigation
    vim.cmd("wincmd " .. direction)
  end
end

-- Ctrl + H/J/K/L navigation
map("n", "<C-h>", function() smart_nav("h") end, { desc = "Move left / focus NvimTree" })
map("n", "<C-j>", function() smart_nav("j") end, { desc = "Move down" })
map("n", "<C-k>", function() smart_nav("k") end, { desc = "Move up" })
map("n", "<C-l>", function() smart_nav("l") end, { desc = "Move right" })

-- Open current HTML file in default browser
map("n", "<leader>oh", function()
  local file = vim.fn.expand("%:p")

  if file == "" then
    vim.notify("No file open", vim.log.levels.WARN)
    return
  end

  if vim.bo.filetype ~= "html" then
    vim.notify("Current file is not an HTML file", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstart({ "xdg-open", file }, { detach = true })
end, { desc = "Open HTML in browser" })

-- Avante AI shortcuts
map("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Avante Ask" })
map("v", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Avante Ask selected code" })

map("n", "<leader>ac", "<cmd>AvanteChat<CR>", { desc = "Avante Chat" })
map("n", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "Avante Edit" })
map("v", "<leader>ae", "<cmd>AvanteEdit<CR>", { desc = "Avante Edit selected code" })

map("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { desc = "Avante Refresh" })
map("n", "<leader>at", "<cmd>AvanteToggle<CR>", { desc = "Avante Toggle sidebar" })
