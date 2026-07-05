-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- System clipboard: y/p langsung sync dengan clipboard OS (Wayland/X11)
vim.opt.clipboard = "unnamedplus"

-- Fix double-key di Kitty terminal:
-- ttimeoutlen mengontrol berapa lama Neovim menunggu setelah Escape sequence.
-- Nilai 0 bisa menyebabkan sequence terbaca dua kali; 10ms adalah nilai aman.
vim.opt.ttimeoutlen = 10

-- =============================================================================
-- .env Loader
-- Membaca ~/.config/nvim/.env dan mengexport setiap KEY=VALUE sebagai
-- environment variable, sehingga plugin (contoh: codecompanion) bisa
-- mengambilnya via os.getenv() tanpa menyimpan key di dalam file konfigurasi.
--
-- Format .env:
--   ANTHROPIC_API_KEY=sk-ant-...
--   OPENAI_API_KEY=sk-...
--   # ini komentar, diabaikan
-- =============================================================================
local env_path = vim.fn.stdpath("config") .. "/.env"
if vim.fn.filereadable(env_path) == 1 then
  for _, line in ipairs(vim.fn.readfile(env_path)) do
    -- Abaikan baris kosong dan komentar
    if line ~= "" and not line:match("^%s*#") then
      local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
      if key and value and value ~= "" then
        vim.fn.setenv(key, value)
      end
    end
  end
end

