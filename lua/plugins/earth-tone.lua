-- =============================================================================
-- lua/plugins/earth-tone.lua
-- Override warna UI ke palet "Earth Tone" — Coklat Soft & Putih Tulang
--
-- Palet yang digunakan:
--   #D8D5CD  Putih Tulang/Abu Hangat  — teks normal
--   #A68969  Coklat Soft              — directory / folder
--   #8C6A48  Coklat Tua               — ikon folder, border, line number
--   #C49F5D  Kuning Kuningan          — judul / title
--   #688F68  Hijau Ivy                — string / symbol positif
--   #B06A62  Merah Bata               — error / diagnostik
-- =============================================================================

-- Warna palet Earth Tone
local E = {
  fg         = "#D8D5CD", -- Putih Tulang — teks biasa
  dir        = "#A68969", -- Coklat Soft  — folder/directory
  dir_icon   = "#8C6A48", -- Coklat Tua   — ikon folder
  title      = "#C49F5D", -- Kuning Kuningan — title/header
  accent     = "#8C6A48", -- Coklat Tua   — border, line number
  green      = "#688F68", -- Hijau Ivy
  red        = "#B06A62", -- Merah Bata
  muted      = "#7A7060", -- Abu coklat   — komentar, teks redup
}

-- Terapkan highlight setiap kali colorscheme berubah
-- agar override tetap aktif meski tema di-reload
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()

    -- ------------------------------------------------------------------
    -- TEKS UMUM
    -- ------------------------------------------------------------------
    -- Normal text: putih tulang hangat
    vim.api.nvim_set_hl(0, "Normal",       { fg = E.fg })
    vim.api.nvim_set_hl(0, "NormalNC",     { fg = E.fg })  -- window non-aktif
    vim.api.nvim_set_hl(0, "NormalFloat",  { fg = E.fg, bg = "NONE" })

    -- ------------------------------------------------------------------
    -- DIRECTORY & FILE ICON (dipakai oleh neo-tree, nvim-tree, dll)
    -- ------------------------------------------------------------------
    -- Nama folder/directory: coklat soft
    vim.api.nvim_set_hl(0, "Directory",            { fg = E.dir, bold = true })
    -- Ikon folder (dipakai nvim-web-devicons & neo-tree)
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = E.dir_icon })
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = E.dir })
    vim.api.nvim_set_hl(0, "NeoTreeRootName",      { fg = E.dir_icon, bold = true })
    -- File biasa di neo-tree
    vim.api.nvim_set_hl(0, "NeoTreeFileName",      { fg = E.fg })
    vim.api.nvim_set_hl(0, "NeoTreeFileIcon",      { fg = E.muted })
    -- Indentasi & garis penghubung neo-tree
    vim.api.nvim_set_hl(0, "NeoTreeIndentMarker",  { fg = E.accent })
    vim.api.nvim_set_hl(0, "NeoTreeExpander",      { fg = E.dir_icon })

    -- ------------------------------------------------------------------
    -- TITLE & HEADER
    -- ------------------------------------------------------------------
    vim.api.nvim_set_hl(0, "Title",           { fg = E.title, bold = true })
    vim.api.nvim_set_hl(0, "FloatTitle",      { fg = E.title, bold = true })
    -- Dashboard header (SnacksDashboard)
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = E.fg })
    vim.api.nvim_set_hl(0, "SnacksDashboardTitle",  { fg = E.title, bold = true })
    vim.api.nvim_set_hl(0, "SnacksDashboardIcon",   { fg = E.dir })

    -- ------------------------------------------------------------------
    -- GUTTER & LINE NUMBER
    -- ------------------------------------------------------------------
    vim.api.nvim_set_hl(0, "LineNr",       { fg = E.accent })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = E.dir, bold = true })
    vim.api.nvim_set_hl(0, "SignColumn",   { fg = E.accent })

    -- ------------------------------------------------------------------
    -- BORDER & SEPARATOR
    -- ------------------------------------------------------------------
    vim.api.nvim_set_hl(0, "FloatBorder",       { fg = E.accent })
    vim.api.nvim_set_hl(0, "WinSeparator",      { fg = E.accent })
    vim.api.nvim_set_hl(0, "TelescopeBorder",   { fg = E.accent })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = E.dir })

    -- ------------------------------------------------------------------
    -- STATUS LINE
    -- ------------------------------------------------------------------
    vim.api.nvim_set_hl(0, "StatusLine",   { fg = E.fg,    bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = E.muted, bg = "NONE" })

    -- ------------------------------------------------------------------
    -- KOMENTAR
    -- ------------------------------------------------------------------
    vim.api.nvim_set_hl(0, "Comment", { fg = E.muted, italic = true })

  end,
})

-- Terapkan juga saat startup (sebelum event ColorScheme pertama)
vim.schedule(function()
  vim.cmd("doautocmd ColorScheme *")
end)

-- Plugin spec kosong — tidak ada plugin baru yang dibutuhkan
return {}
