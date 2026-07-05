-- =============================================================================
-- lua/plugins/ai.lua
-- AI & Bantuan Coding via codecompanion.nvim
--
-- Setup adapter:
--   Claude  → export ANTHROPIC_API_KEY="sk-ant-..."
--   OpenAI  → export ANTHROPIC_API_KEY="sk-..."
--   Gemini  → export GEMINI_API_KEY="..."
--   Ollama  → tidak perlu API key, cukup jalankan: ollama serve
-- =============================================================================

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Render markdown di chat buffer
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    },
    event = "VeryLazy",
    keys = {
      -- Chat: buka jendela percakapan interaktif dengan AI
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",  desc = "AI Chat Toggle" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>",         desc = "AI Chat Baru" },

      -- Inline: tanya AI langsung di buffer (hasilnya disisipkan di kode)
      { "<leader>ai", "<cmd>CodeCompanion<cr>",             desc = "AI Inline Prompt", mode = { "n", "v" } },

      -- Action palette: menu semua aksi AI yang tersedia
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>",      desc = "AI Actions", mode = { "n", "v" } },

      -- Shortcut visual: pilih kode lalu tanya AI
      { "<leader>ae", "<cmd>CodeCompanionChat Add<cr>",     desc = "AI: Tambah ke Chat", mode = "v" },
    },
    opts = {
      -- -----------------------------------------------------------------------
      -- ADAPTER: pilih provider AI default
      -- Ganti "anthropic" ke "openai" / "ollama" / "gemini" sesuai kebutuhan
      -- -----------------------------------------------------------------------
      strategies = {
        chat = {
          adapter = "anthropic", -- provider untuk mode chat
          roles = {
            llm  = "  CodeCompanion",
            user = "  Kamu",
          },
          keymaps = {
            send           = { modes = { n = "<CR>", i = "<C-s>" } },
            close          = { modes = { n = "q" } },
            stop           = { modes = { n = "<C-c>" } },
            clear          = { modes = { n = "<C-l>" } },
            codeblock      = { modes = { n = "gc" } },
            yank_code      = { modes = { n = "gy" } },
          },
        },
        inline = {
          adapter = "anthropic", -- provider untuk inline prompt
        },
        agent = {
          adapter = "anthropic",
        },
      },

      -- -----------------------------------------------------------------------
      -- ADAPTERS: konfigurasi tiap provider
      -- -----------------------------------------------------------------------
      adapters = {
        -- Claude (Anthropic) — model terbaik untuk coding
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = { api_key = "ANTHROPIC_API_KEY" },
            schema = {
              model = {
                default = "claude-sonnet-4-5", -- ganti ke claude-opus-4 untuk versi terkuat
              },
            },
          })
        end,

        -- OpenAI (GPT)
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = { api_key = "OPENAI_API_KEY" },
            schema = {
              model = {
                default = "gpt-4o",
              },
            },
          })
        end,

        -- Google Gemini
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = { api_key = "GEMINI_API_KEY" },
            schema = {
              model = {
                default = "gemini-2.0-flash",
              },
            },
          })
        end,

        -- Ollama (model lokal, tidak perlu API key)
        -- Pastikan Ollama sudah berjalan: ollama serve
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "codellama:latest", -- atau qwen2.5-coder, deepseek-coder
              },
            },
          })
        end,
      },

      -- -----------------------------------------------------------------------
      -- TAMPILAN
      -- -----------------------------------------------------------------------
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "  Pilih Aksi AI ",
          provider = "telescope", -- gunakan telescope sebagai picker
        },
        chat = {
          window = {
            layout = "vertical", -- "vertical" | "horizontal" | "float" | "buffer"
            width  = 0.35,       -- 35% lebar layar
          },
          show_settings = false, -- sembunyikan panel settings di chat
          show_token_count = true,
          render_markdown = true,
        },
        inline = {
          diff = {
            enabled = true,
            priority = 130,
            hl_groups = {
              added   = "DiffAdd",
              removed = "DiffDelete",
            },
          },
        },
      },

      -- -----------------------------------------------------------------------
      -- PROMPT LIBRARY: aksi cepat via <leader>aa
      -- -----------------------------------------------------------------------
      prompt_library = {
        ["Jelaskan Kode"] = {
          strategy = "chat",
          description = "Jelaskan kode yang dipilih dalam bahasa Indonesia",
          opts = { mapping = "<leader>axe", modes = { "v" }, auto_submit = true },
          prompts = {
            {
              role = "user",
              content = function(context)
                return "Jelaskan kode berikut dalam bahasa Indonesia secara detail:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
        ["Perbaiki Bug"] = {
          strategy = "inline",
          description = "Minta AI memperbaiki bug di kode yang dipilih",
          opts = { mapping = "<leader>axf", modes = { "v" }, auto_submit = true },
          prompts = {
            {
              role = "user",
              content = function(context)
                return "Temukan dan perbaiki bug di kode berikut, berikan penjelasan singkat:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
        ["Tulis Unit Test"] = {
          strategy = "chat",
          description = "Generate unit test untuk kode yang dipilih",
          opts = { mapping = "<leader>axt", modes = { "v" }, auto_submit = true },
          prompts = {
            {
              role = "user",
              content = function(context)
                return "Tulis unit test yang komprehensif untuk kode berikut:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
        ["Refactor"] = {
          strategy = "inline",
          description = "Refactor kode yang dipilih agar lebih bersih",
          opts = { mapping = "<leader>axr", modes = { "v" }, auto_submit = true },
          prompts = {
            {
              role = "user",
              content = function(context)
                return "Refactor kode berikut agar lebih clean, readable, dan efisien. Jaga fungsionalitas tetap sama:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  .. "\n```"
              end,
            },
          },
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Supermaven — Inline Code Completion (Gratis)
  --    Autocomplete real-time saat mengetik, seperti Copilot.
  --    Tidak perlu API key atau akun — free tier aktif otomatis.
  --
  --    Cara kerja:
  --      • Saran muncul sebagai ghost text (abu-abu) di sebelah kanan cursor
  --      • Tab        → terima saran penuh
  --      • Ctrl+]     → terima satu kata
  --      • Ctrl+[     → tolak / tutup saran
  --      • <leader>sm → toggle Supermaven on/off
  -- ---------------------------------------------------------------------------
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    opts = {
      keymaps = {
        accept_suggestion  = "<Tab>",
        clear_suggestion   = "<C-]>",
        accept_word        = "<C-j>",
      },
      ignore_filetypes = {
        -- Jangan aktifkan di file-file non-kode
        "TelescopePrompt", "neo-tree", "lazy", "mason",
        "help", "dashboard", "alpha", "snacks_dashboard",
      },
      color = {
        suggestion_color = "#6e7681", -- abu-abu muted, tidak mengganggu kode
        cterm = 244,
      },
      log_level = "off",
      disable_inline_completion = false,
      disable_keymaps = false,
    },
    keys = {
      {
        "<leader>sm",
        function()
          local sm = require("supermaven-nvim.api")
          if sm.is_running() then
            sm.stop()
            vim.notify("Supermaven dimatikan", vim.log.levels.INFO, { title = "Supermaven" })
          else
            sm.start()
            vim.notify("Supermaven diaktifkan", vim.log.levels.INFO, { title = "Supermaven" })
          end
        end,
        desc = "Toggle Supermaven",
      },
    },
  },
}
