return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- Required
      "sindrets/diffview.nvim",        -- Optional, for better diffs
      "nvim-telescope/telescope.nvim", -- Optional, for Telescope integration
    },
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true,  -- enables diffview integration
          telescope = true, -- enables telescope integration
        },
      })
    end,
  },
}

