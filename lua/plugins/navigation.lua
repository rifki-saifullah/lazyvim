-- =============================================================================
-- lua/plugins/navigation.lua
-- Plugin navigasi & manipulasi teks
-- =============================================================================

return {

  -- ---------------------------------------------------------------------------
  -- 1. flash.nvim
  --    LazyVim sudah meng-include flash.nvim. File ini hanya untuk kustomisasi.
  --    Tekan `s` (Normal/Visual) atau `r` (Operator-pending) untuk melompat.
  -- ---------------------------------------------------------------------------
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- Tampilkan label di awal kata agar lebih mudah dibaca
      label = {
        uppercase = false,
        -- Warna label mengikuti highlight FlashLabel
      },
      modes = {
        -- `s` → flash search (default LazyVim)
        search = { enabled = false }, -- nonaktifkan auto-flash saat `/` search biasa
        char = {
          -- `f`, `F`, `t`, `T` dipercepat dengan flash
          enabled = true,
          jump_labels = true,
        },
      },
    },
    keys = {
      -- Tekan `s` di Normal/Visual untuk flash jump
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash Jump" },
      -- Tekan `S` untuk treesitter-aware selection
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- `r` di operator-pending mode (misalnya `yr`, `dr`)
      { "r", mode = "o",               function() require("flash").remote() end,      desc = "Flash Remote" },
      -- `R` untuk treesitter search di operator-pending & visual
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
      -- `<C-s>` di command mode untuk toggle flash search
      { "<c-s>", mode = { "c" },       function() require("flash").toggle() end,     desc = "Toggle Flash Search" },
    },
  },

  -- ---------------------------------------------------------------------------
  -- 2. nvim-surround
  --    Bungkus / ganti / hapus pasangan karakter dengan cepat.
  --
  --    Contoh keycap (Normal mode):
  --      ys<motion><char>  → tambah surround  (ysiw" → bungkus kata dengan "")
  --      cs<old><new>      → ganti surround   (cs"' → ubah "" jadi '')
  --      ds<char>          → hapus surround   (ds" → hapus tanda kutip)
  --    Visual mode:
  --      S<char>           → bungkus seleksi
  -- ---------------------------------------------------------------------------
  {
    "kylechui/nvim-surround",
    version = "*", -- gunakan release stabil terbaru
    event = "VeryLazy",
    -- v4+: keymaps tidak lagi dikonfigurasi via setup()
    -- Default sudah mencakup: ys, yss, yS, S, ds, cs, cS
    opts = {},
  },

  -- ---------------------------------------------------------------------------
  -- 3. mini.bracketed
  --    Navigasi konsisten dengan [ / ] untuk berbagai "elemen":
  --      [b / ]b  → buffer sebelumnya / berikutnya
  --      [d / ]d  → diagnostic
  --      [f / ]f  → file di direktori yang sama
  --      [h / ]h  → git hunk
  --      [i / ]i  → indent
  --      [j / ]j  → jumplist
  --      [l / ]l  → location list
  --      [q / ]q  → quickfix
  --      [t / ]t  → treesitter node
  --      [u / ]u  → undo history
  --      [w / ]w  → window
  --      [x / ]x  → conflict marker
  -- ---------------------------------------------------------------------------
  {
    "nvim-mini/mini.bracketed",
    version = false,
    event = "VeryLazy",
    opts = {
      -- Aktifkan semua modul yang berguna; set suffix = "" untuk menonaktifkan
      buffer     = { suffix = "b", options = {} },
      comment    = { suffix = "c", options = {} },
      conflict   = { suffix = "x", options = {} },
      diagnostic = { suffix = "d", options = {} },
      file       = { suffix = "f", options = {} },
      indent     = { suffix = "i", options = {} },
      jump       = { suffix = "j", options = {} },
      location   = { suffix = "l", options = {} },
      oldfile    = { suffix = "o", options = {} },
      quickfix   = { suffix = "q", options = {} },
      treesitter = { suffix = "t", options = {} },
      undo       = { suffix = "u", options = {} },
      window     = { suffix = "w", options = {} },
      yank       = { suffix = "y", options = {} },
    },
  },
}
