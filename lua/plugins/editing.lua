-- =============================================================================
-- lua/plugins/editing.lua
-- Pengolahan Data & Automasi
-- =============================================================================

return {

  -- ---------------------------------------------------------------------------
  -- 1. dial.nvim
  --    Increment/decrement cerdas dengan <C-a> dan <C-x>.
  --    Mendukung: angka, boolean, hari, bulan, hex, semver, dll.
  --
  --    Contoh:
  --      <C-a>  → true → false, Monday → Tuesday, 0xff → 0x00, 1 → 2
  --      <C-x>  → kebalikannya
  --      g<C-a> / g<C-x> → increment sekuensial pada visual block
  -- ---------------------------------------------------------------------------
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>",  function() require("dial.map").manipulate("increment", "normal")  end, desc = "Dial Increment" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal")  end, desc = "Dial Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Dial Increment (sequential)" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Dial Decrement (sequential)" },
      { "<C-a>",  function() require("dial.map").manipulate("increment", "visual")  end, mode = "v", desc = "Dial Increment (visual)" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual")  end, mode = "v", desc = "Dial Decrement (visual)" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v", desc = "Dial Increment (visual sequential)" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v", desc = "Dial Decrement (visual sequential)" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,       -- angka desimal
          augend.integer.alias.hex,           -- 0xff
          augend.integer.alias.octal,         -- 0o77
          augend.integer.alias.binary,        -- 0b1010
          augend.date.alias["%Y/%m/%d"],      -- tanggal
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%d/%m/%Y"],
          augend.constant.alias.bool,         -- true ↔ false
          augend.semver.alias.semver,         -- 1.2.3 → 1.2.4
          augend.constant.new({               -- on ↔ off
            elements = { "on", "off" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({               -- yes ↔ no
            elements = { "yes", "no" },
            word = true,
            cyclic = true,
          }),
          augend.constant.new({               -- && ↔ ||
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          }),
        },
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- 2. nvim-spider
  --    Menggantikan w, e, b dengan versi yang sadar sub-word.
  --    Berhenti di setiap bagian camelCase, snake_case, PascalCase.
  --
  --    Contoh: `myVariableName`
  --      w standar : lompat ke seluruh kata
  --      w spider  : my → Variable → Name (tiga langkah)
  --
  --    Keycap: w, e, b, ge (sama seperti standar Vim, tinggal pakai)
  -- ---------------------------------------------------------------------------
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    keys = {
      { "w",  function() require("spider").motion("w")  end, mode = { "n", "o", "x" }, desc = "Spider w (subword)" },
      { "e",  function() require("spider").motion("e")  end, mode = { "n", "o", "x" }, desc = "Spider e (subword)" },
      { "b",  function() require("spider").motion("b")  end, mode = { "n", "o", "x" }, desc = "Spider b (subword)" },
      { "ge", function() require("spider").motion("ge") end, mode = { "n", "o", "x" }, desc = "Spider ge (subword)" },
    },
    opts = {
      skipInsignificantPunctuation = true, -- abaikan tanda baca kecil (titik, koma)
    },
  },
}
