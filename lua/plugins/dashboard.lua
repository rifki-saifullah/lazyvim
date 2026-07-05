return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
           |\      _,,,---,,_           
     ZZZzz /,`.-'`'    -.  ;-;;,_       
          |,4-  ) )-,_. ,\ (  `'-'      
         '---''(_/--'  `-'\_)           
                                        
          ✦  LAZYVIM  ✦         
          ]],
        },
      },
    },
    init = function()
      -- Memastikan header memiliki warna putih soft saat dashboard dimuat
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = function()
          -- Set warna putih soft (hex: #e2e2e3) untuk header dashboard
          vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#e2e2e3" })
        end,
      })

      -- Fallback di event ColorScheme jika tema diubah
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#e2e2e3" })
        end,
      })
    end,
  },
}
