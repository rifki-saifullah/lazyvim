return {
  -- Catppuccin: tema dark dengan teks putih bersih
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- "latte" | "frappe" | "macchiato" | "mocha" (paling gelap, teks paling putih)

      -- Background transparent agar menggunakan bg dari Kitty
      transparent_background = true,

      -- Matikan dim pada window tidak aktif agar tetap konsisten
      dim_inactive = {
        enabled = false,
      },

      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        keywords = { "bold" },
        functions = {},
        strings = {},
        variables = {},
      },

      -- Integrations populer
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        telescope = { enabled = true },
        which_key = true,
        indent_blankline = { enabled = true },
        mini = { enabled = true },
        mason = true,
        nvimtree = true,
        noice = true,
      },

      -- Override highlight agar floating window juga transparan
      highlight_overrides = {
        mocha = function(colors)
          return {
            NormalFloat = { bg = "NONE" },
            FloatBorder = { fg = colors.lavender, bg = "NONE" },
            TelescopeNormal = { bg = "NONE" },
            TelescopeBorder = { fg = colors.lavender, bg = "NONE" },
            TelescopePromptBorder = { fg = colors.blue, bg = "NONE" },
            LazyNormal = { bg = "NONE" },
            MasonNormal = { bg = "NONE" },
          }
        end,
      },
    },
  },

  -- Set colorscheme di LazyVim
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
