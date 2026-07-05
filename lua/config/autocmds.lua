-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- =============================================================================
-- Auto-show diagnostic float saat cursor diam di baris error
-- =============================================================================
local diag_float_opts = {
  style      = "minimal",
  border     = "rounded",
  source     = "always",
  header     = "",
  prefix     = "",
  max_width  = math.floor(vim.o.columns * 0.8),
  max_height = 20,
  wrap       = true,
  focusable  = false,
  scope      = "line",
}

vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("DiagnosticAutoFloat", { clear = true }),
  callback = function()
    -- Skip jika cursor sudah di dalam float window
    if vim.api.nvim_win_get_config(0).relative ~= "" then return end

    -- Skip jika tidak ada diagnostic di baris ini
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    if #vim.diagnostic.get(0, { lnum = lnum }) == 0 then return end

    -- Skip jika sudah ada float window terbuka
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= "" then return end
    end

    vim.diagnostic.open_float(nil, diag_float_opts)
  end,
})
