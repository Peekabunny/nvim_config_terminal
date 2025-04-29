return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        -- Your Neo-tree configuration here
        close_if_last_window = true,
        window = {
          mappings = {
            ["<space>"] = "none", -- Disable default <space> mapping
          }
        }
      })
      
      -- Neo-tree auto-refresh after Lazy sync
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazySync",
        callback = function()
          vim.schedule(function()
            local ok, neo_tree = pcall(require, "neo-tree.sources.manager")
            if ok then
              neo_tree.refresh("filesystem")
              vim.cmd("Neotree show")
            end
          end)
        end,
      })
    end,
  }
}
