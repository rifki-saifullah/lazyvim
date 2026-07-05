-- =============================================================================
-- lua/plugins/git.lua
-- Git & Produktivitas
-- =============================================================================

return {

  -- ---------------------------------------------------------------------------
  -- 1. neogit
  --    Git UI modern yang intuitif, terinspirasi dari Magit (Emacs).
  --    Mendukung staging per-hunk, rebase interaktif, log, blame, dll.
  --
  --    Keycap:
  --      <leader>gg  → buka Neogit (sama seperti lazygit di LazyVim)
  --      <leader>gG  → buka Neogit di direktori saat ini
  --      <leader>gc  → commit
  --      <leader>gP  → push
  --      <leader>gp  → pull
  --
  --    Di dalam Neogit:
  --      ?  → tampilkan semua keycap yang tersedia
  --      s  → stage hunk/file
  --      u  → unstage
  --      cc → commit
  --      P  → push
  -- ---------------------------------------------------------------------------
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- diff view yang lebih kaya
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", function() require("neogit").open() end,                          desc = "Neogit" },
      { "<leader>gG", function() require("neogit").open({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Neogit (dir file)" },
      { "<leader>gc", function() require("neogit").open({ "commit" }) end,              desc = "Neogit Commit" },
      { "<leader>gP", function() require("neogit").open({ "push" }) end,               desc = "Neogit Push" },
      { "<leader>gp", function() require("neogit").open({ "pull" }) end,               desc = "Neogit Pull" },
    },
    opts = {
      -- Tampilan: split vertikal lebih nyaman di layar lebar
      -- "auto" → gunakan tab jika layar kecil, split jika lebar
      kind = "split",

      -- Integrasikan dengan diffview.nvim untuk diff yang lebih kaya
      integrations = {
        diffview = true,
        telescope = true,
      },

      -- Tampilkan tanda di gutter juga dari neogit (gunakan gitsigns saja)
      signs = {
        -- hunk headers
        hunk = { "", "" },
        item = { ">", "v" },
        section = { ">", "v" },
      },

      -- Commit editor: pakai split bawah agar tidak kehilangan konteks
      commit_editor = {
        kind = "split",
        show_staged_diff = true,
        staged_diff_split_kind = "split_above",
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- 2. diffview.nvim
  --    Dependency neogit — tapi berguna juga secara standalone.
  --    Membuka diff view yang kaya dengan file tree di samping.
  --
  --    Keycap:
  --      <leader>gd  → buka diffview (perubahan working tree)
  --      <leader>gh  → buka file history
  --      <leader>gD  → tutup diffview
  -- ---------------------------------------------------------------------------
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",       desc = "Diffview Open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview File History" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>",      desc = "Diffview Close" },
    },
    opts = {
      enhanced_diff_hl = true,
    },
  },

  -- ---------------------------------------------------------------------------
  -- 3. gitsigns.nvim
  --    Sudah di-bundle LazyVim — entry ini hanya untuk menambah keycap
  --    dan menyesuaikan tampilan tanda gutter.
  --
  --    Keycap tambahan:
  --      ]h / [h  → hunk berikutnya / sebelumnya
  --      <leader>ghs → stage hunk
  --      <leader>ghr → reset hunk
  --      <leader>ghp → preview hunk
  --      <leader>ghb → blame baris saat ini
  -- ---------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      -- current_line_blame dimatikan: git-blame.nvim sudah menampilkan
      -- blame di semua baris termasuk baris cursor (mencegah info double)
      current_line_blame = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, silent = true })
        end

        -- Navigasi hunk
        map("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "Next Hunk")

        map("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "Prev Hunk")

        -- Actions
        map("n", "<leader>ghs", gs.stage_hunk,                    "Stage Hunk")
        map("n", "<leader>ghr", gs.reset_hunk,                    "Reset Hunk")
        map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage Hunk (visual)")
        map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset Hunk (visual)")
        map("n", "<leader>ghS", gs.stage_buffer,                  "Stage Buffer")
        map("n", "<leader>ghR", gs.reset_buffer,                  "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk,                  "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", gs.toggle_current_line_blame,     "Toggle Line Blame")
        map("n", "<leader>ghd", gs.diffthis,                      "Diff This")
      end,
    },
  },

  -- ---------------------------------------------------------------------------
  -- 4. git-blame.nvim
  --    Menampilkan info blame (author, waktu, pesan commit) sebagai virtual
  --    text di sebelah KANAN setiap baris — bukan hanya baris cursor.
  --
  --    Keycap:
  --      <leader>gtb  → toggle tampilan blame semua baris
  --      <leader>gto  → buka commit di browser
  -- ---------------------------------------------------------------------------
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>gtb", "<cmd>GitBlameToggle<cr>",         desc = "Toggle Git Blame (all lines)" },
      { "<leader>gto", "<cmd>GitBlameOpenCommitURL<cr>",  desc = "Open Commit URL" },
      { "<leader>gts", "<cmd>GitBlameCopySHA<cr>",        desc = "Copy Commit SHA" },
    },
    opts = {
      enabled = true,              -- aktif saat startup
      message_template = " 󰊢 <author> · <date> · <summary>",
      date_format = "%d %b %Y",
      virtual_text_column = 1,     -- mulai tepat setelah kode (eol)
      highlight_group = "GitBlameVirtualText",
      -- Jangan tampilkan di file tipe ini
      ignored_filetypes = {
        "neo-tree", "NvimTree", "TelescopePrompt",
        "help", "lazy", "mason", "dashboard",
        "alpha", "snacks_dashboard", "toggleterm",
      },
      delay = 500, -- ms sebelum virtual text muncul
    },
    config = function(_, opts)
      require("gitblame").setup(opts)
      -- Warna virtual text: abu-abu halus agar tidak mengganggu kode
      vim.api.nvim_set_hl(0, "GitBlameVirtualText", {
        fg = "#6e7681",
        italic = true,
      })
    end,
  },
}
