-- =============================================================================
-- lua/plugins/php.lua
-- PHP & Laravel Development Stack
--
-- Mencakup:
--   • LSP (Intelephense / Phpactor)
--   • Formatting (Laravel Pint / php-cs-fixer)
--   • Linting (PHPStan / Psalm)
--   • Testing (Neotest + PHPUnit + Pest)
--   • Laravel (Artisan, Route, Model, Blade)
--   • Blade template support
-- =============================================================================

return {

  -- ---------------------------------------------------------------------------
  -- 1. Mason: auto-install tools PHP
  --    Jalankan :MasonInstall untuk install manual jika diperlukan
  -- ---------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "intelephense",  -- PHP LSP (rekomendasi utama)
        "phpactor",      -- PHP LSP alternatif (lebih ringan)
        "php-cs-fixer",  -- Formatter PSR-12
        "pint",          -- Laravel opinionated formatter
        "phpstan",       -- Static analysis
        -- "psalm-language-server" tidak tersedia di Mason registry
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- 2. LSP: Intelephense
  --    Fitur: autocomplete, go-to-definition, hover docs, rename, dll.
  --    Tip: untuk fitur premium (namespace sort, license), beli lisensi
  --         dan set vim.g.intelephense_licence_key = "..."
  -- ---------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              stubs = {
                -- Aktifkan stub umum + Laravel
                "bcmath", "bz2", "calendar", "Core", "curl", "date",
                "dba", "dom", "enchant", "fileinfo", "filter", "ftp",
                "gd", "gettext", "hash", "iconv", "imap", "intl",
                "json", "ldap", "libxml", "mbstring", "mcrypt",
                "mysql", "mysqli", "password", "pcntl", "pcre",
                "PDO", "pdo_mysql", "Phar", "readline", "recode",
                "Reflection", "regex", "session", "SimpleXML",
                "soap", "sockets", "sodium", "SPL", "standard",
                "superglobals", "sysvmsg", "sysvsem", "sysvshm",
                "tidy", "tokenizer", "xml", "xdebug", "xmlreader",
                "xmlrpc", "xmlwriter", "xsl", "zip", "zlib",
                "wordpress", "woocommerce",
              },
              environment = {
                phpVersion = "8.3",
              },
              files = {
                maxSize = 5000000, -- 5MB — cukup untuk project Laravel besar
              },
              phpdoc = {
                returnVoid = false,
              },
            },
          },
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- 3. Formatting: Laravel Pint & php-cs-fixer via conform.nvim
  --    Prioritas: jika ada pint di vendor/ → pakai pint, selain itu php-cs-fixer
  -- ---------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.php = { "pint", "php_cs_fixer", stop_after_first = true }
      opts.formatters_by_ft.blade = { "blade-formatter" }

      opts.formatters = opts.formatters or {}
      -- Gunakan pint dari vendor/ project jika ada
      opts.formatters.pint = {
        command = function()
          local local_pint = vim.fn.getcwd() .. "/vendor/bin/pint"
          return vim.fn.filereadable(local_pint) == 1 and local_pint or "pint"
        end,
      }
    end,
  },

  -- ---------------------------------------------------------------------------
  -- 4. Blade Template Support
  --    Syntax highlighting + indentasi untuk file .blade.php
  -- ---------------------------------------------------------------------------
  {
    -- Treesitter grammar untuk Blade
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "php", "phpdoc" })
    end,
  },
  {
    -- Blade syntax (vim-script, paling stabil)
    "jwalton512/vim-blade",
    ft = "blade",
  },


  -- ---------------------------------------------------------------------------
  -- 5. laravel.nvim
  --    Integrasi penuh dengan ekosistem Laravel:
  --      • Artisan command runner
  --      • Route list & navigasi
  --      • Model info
  --      • View/Component navigation
  --
  --    Keycap (semua di bawah <leader>l):
  --      <leader>la  → Artisan command picker
  --      <leader>lr  → Route list
  --      <leader>lm  → Model info
  --      <leader>lv  → Buka view terkait
  -- ---------------------------------------------------------------------------
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Laravel" },
    keys = {
      { "<leader>la", "<cmd>Laravel artisan<cr>",   desc = "Laravel Artisan" },
      { "<leader>lr", "<cmd>Laravel routes<cr>",    desc = "Laravel Routes" },
      { "<leader>lm", "<cmd>Laravel related<cr>",   desc = "Laravel Related Files" },
    },
    event = { "VeryLazy" },
    opts = {
      lsp_server = "intelephense",
      features = {
        null_ls = {
          enable = false, -- gunakan conform.nvim + nvim-lint saja
        },
        route_info = {
          enable = true,
          position = "right",  -- tampilkan info route di sebelah kanan (virtual text)
          middlewares = true,
          method = true,
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- 6. Neotest: Test Runner Framework
  --    Mendukung PHPUnit dan Pest dalam satu antarmuka.
  --
  --    Keycap (semua di bawah <leader>t):
  --      <leader>tt  → Jalankan test di cursor
  --      <leader>tf  → Jalankan semua test di file
  --      <leader>ts  → Jalankan test suite lengkap
  --      <leader>tl  → Jalankan ulang test terakhir
  --      <leader>to  → Buka output hasil test
  --      <leader>tS  → Toggle summary panel
  --      <leader>tw  → Toggle watch mode (re-run saat file berubah)
  -- ---------------------------------------------------------------------------
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapter PHPUnit
      "olimorris/neotest-phpunit",
      -- Adapter Pest
      "V13Axel/neotest-pest",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end,                                       desc = "Test: Jalankan (cursor)" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,                     desc = "Test: Jalankan File" },
      { "<leader>ts", function() require("neotest").run.run({ suite = true }) end,                       desc = "Test: Jalankan Suite" },
      { "<leader>tl", function() require("neotest").run.run_last() end,                                  desc = "Test: Ulangi Terakhir" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test: Lihat Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end,                           desc = "Test: Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").summary.toggle() end,                                desc = "Test: Toggle Summary" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                desc = "Test: Toggle Watch" },
      { "<leader>tx", function() require("neotest").run.stop() end,                                      desc = "Test: Stop" },
    },
    opts = function()
      return {
        adapters = {
          -- ── PHPUnit ─────────────────────────────────────────────────────
          require("neotest-phpunit")({
            phpunit_cmd = function()
              -- Gunakan phpunit dari vendor/ jika ada
              local local_bin = vim.fn.getcwd() .. "/vendor/bin/phpunit"
              return vim.fn.filereadable(local_bin) == 1 and local_bin or "phpunit"
            end,
            -- Jalankan dengan config phpunit.xml / phpunit.xml.dist
            root_files = { "phpunit.xml", "phpunit.xml.dist", "composer.json" },
            filter_dirs = { ".git", "node_modules", "vendor" },
          }),

          -- ── Pest ────────────────────────────────────────────────────────
          require("neotest-pest")({
            pest_cmd = function()
              -- Gunakan pest dari vendor/ jika ada
              local local_bin = vim.fn.getcwd() .. "/vendor/bin/pest"
              return vim.fn.filereadable(local_bin) == 1 and local_bin or "pest"
            end,
            -- Pest bisa di-detect dari composer.json juga
            root_files = { "pest.xml", "phpunit.xml", "composer.json" },
          }),
        },

        -- Tampilan status di gutter (ikon hasil test)
        icons = {
          passed   = "✓",
          failed   = "✗",
          running  = "↻",
          skipped  = "○",
          unknown  = "?",
          watching = "👀",
        },

        -- Tampilkan diagnostics dari hasil test
        diagnostic = {
          enabled = true,
          severity = vim.diagnostic.severity.ERROR,
        },

        output = {
          open_on_run = "short", -- buka output singkat saat ada test gagal
        },

        quickfix = {
          open = false,
        },

        summary = {
          open = "botright vsplit | vertical resize 50",
        },
      }
    end,
  },

  -- ---------------------------------------------------------------------------
  -- 7. nvim-lint: Static Analysis (PHPStan)
  --    Menampilkan error PHPStan sebagai diagnostics secara real-time.
  -- ---------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.php = { "phpstan" }

      -- Gunakan phpstan.neon dari project jika ada
      opts.linters = opts.linters or {}
      opts.linters.phpstan = {
        cmd = function()
          local local_bin = vim.fn.getcwd() .. "/vendor/bin/phpstan"
          return vim.fn.filereadable(local_bin) == 1 and local_bin or "phpstan"
        end,
      }
    end,
  },
}
