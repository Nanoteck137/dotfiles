require("telescope").setup({
  defaults = {
    -- file_sorter = require("telescope.sorters").get_fzy_sorter,
    prompt_prefix = " > ",
    color_devicons = true,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

require('telescope').load_extension('fzf')

vim.keymap.set('n', '<leader>ff', function() require("telescope.builtin").find_files() end, {})
vim.keymap.set('n', '<leader>bb', function() require("telescope.builtin").buffers() end, {})
vim.keymap.set('n', '<leader>hh', function() require("telescope.builtin").help_tags() end, {})
