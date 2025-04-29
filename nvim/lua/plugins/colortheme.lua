return  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Load before other plugins
    config = function()
      require("onedarkpro").setup({
        colors = {}, -- override specific colors if needed
        highlights = {}, -- override highlight groups if needed
        options = {
          transparency = true, -- Set to true if you want a transparent background
          terminal_colors = true,
          underline = true,
        },
        styles = {
          types = "italic",
          methods = "bold", 
          numbers = "NONE",
          strings = "NONE",
          comments = "italic",
          keywords = "bold,italic",
          constants = "NONE",
          functions = "bold",
          operators = "NONE",
          variables = "NONE",
        },
      })
      vim.cmd("colorscheme onedark") -- or 'onedark_vivid' or 'onedark_dark'

      -- Background transparency logic
      local bg_transparent = true

      -- Toggle background transparency
      local toggle_transparency = function()
        bg_transparent = not bg_transparent
        vim.g.nord_disable_background = bg_transparent
        vim.cmd([[colorscheme onedark]])  -- Reload onedark colorscheme
      end

      -- Keymap to toggle background transparency
      vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
    end
  }
