-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- =============================================================================
-- Diagnostic: Buka dan Masuk ke Popup Error
-- =============================================================================
vim.keymap.set("n", "<leader>ce", function()
  -- Buka popup versi focusable (dengan scope='line' agar muncul dimanapun di baris tsb)
  local float_bufnr, float_winnr = vim.diagnostic.open_float(nil, {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    max_width = math.floor(vim.o.columns * 0.8),
    max_height = 20,
    wrap = true,
    scope = "line",
  })

  if not float_winnr then
    vim.notify("Tidak ada diagnostic di baris ini", vim.log.levels.INFO, { title = "Diagnostic" })
    return
  end

  -- Pindahkan cursor secara eksplisit ke dalam float window
  vim.api.nvim_set_current_win(float_winnr)

  -- Keymaps tambahan di dalam popup agar mudah ditutup
  local buf = float_bufnr or vim.api.nvim_win_get_buf(float_winnr)
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true, nowait = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true, nowait = true })
end, { desc = "Diagnostic: Masuk ke Popup Error" })

-- Daftarkan ke which-key jika belum ada
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    local ok, wk = pcall(require, "which-key")
    if not ok then return end
    wk.add({
      { "<leader>ce", desc = "Masuk ke Popup Error", icon = "💬" },
    })
  end,
})
