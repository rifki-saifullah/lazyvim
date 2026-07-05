-- =============================================================================
-- lua/plugins/diagnostics.lua
-- Diagnostics yang lebih baik:
--   • Virtual text inline dimatikan (tidak terpotong di kanan)
--   • Floating popup muncul otomatis saat cursor di baris error
--   • Popup tampil di bawah/atas baris (bukan pojok layar) agar tidak terpotong
--   • Lebar popup adaptif mengikuti panjang pesan
-- =============================================================================

return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>cy",
        function()
          local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
          local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

          if #diagnostics == 0 then
            vim.notify("Tidak ada diagnostic di baris ini", vim.log.levels.INFO, { title = "Diagnostic" })
            return
          end

          local lines = {}
          for _, d in ipairs(diagnostics) do
            local source = d.source and ("[" .. d.source .. "] ") or ""
            table.insert(lines, source .. d.message)
          end
          local text = table.concat(lines, "\n")

          vim.fn.setreg("+", text)
          vim.fn.setreg('"', text)
          vim.notify("✓ Disalin:\n" .. text, vim.log.levels.INFO, { title = "Diagnostic", timeout = 4000 })
        end,
        desc = "Copy diagnostic error",
      },
    },
    opts = function(_, opts)
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable  = true,
          style      = "minimal",
          border     = "rounded",
          source     = "always",
          header     = "",
          prefix     = "",
          max_width  = math.floor(vim.o.columns * 0.8),
          max_height = 20,
          anchor_bias = "below",
          wrap        = true,
        },
      })
    end,
  },

  {
    -- Konfigurasi global vim.diagnostic (berlaku untuk semua diagnostics,
    -- tidak hanya LSP — termasuk null-ls, nvim-lint, dll.)
    "folke/lazy.nvim",
    init = function()
      vim.diagnostic.config({
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        underline       = true,
        update_in_insert = false,
        severity_sort   = true,
        float = {
          focusable  = true,
          style      = "minimal",
          border     = "rounded",
          source     = "always",
          header     = "",
          prefix     = "",
          max_width  = math.floor(vim.o.columns * 0.8),
          max_height = 20,
          wrap       = true,
        },
      })
    end,
  },
}
