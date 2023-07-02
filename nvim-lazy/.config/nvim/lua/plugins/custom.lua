return {
  {
    dir = "~/plugins/sobble.nvim",
    dependencies = { "telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>fp", "<cmd>Telescope sobble<cr>", desc = "Sobble" },
    },
    config = function()
      require("sobble").setup({
        config_path = "~/projects.json",
      })
      require("telescope").load_extension("sobble")
    end,
  },
  {
    dir = "~/plugins/scorbunny.nvim",
    lazy = false,
  },
  {
    dir = "~/plugins/pignite.nvim",
    keys = {
      {
        "<leader>mm",
        function()
          require("pignite").pick_project()
        end,
        desc = "Pick Project",
      },
    },
  },
}
