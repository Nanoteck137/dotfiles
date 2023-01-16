require "plugins"
require "globals"

-- NOTE(patrik): Simple fix for annoying messages
local banned_messages = { "No information available" }
vim.notify = function(msg, ...)
  for _, banned in ipairs(banned_messages) do
    if msg == banned then return end
  end
  require "notify"(msg, ...)
end

-- vim.notify = require("notify")

-- NOTE(patrik): Great resource
-- https://github.com/nvim-lua/kickstart.nvim

-- TODO(patrik): Explore tabs inside nvim
-- TODO(patrik): Explore quickfix list
-- TODO(patrik): Explore focus
-- TODO(patrik): Add snippet for LICENCE
-- TODO(patrik): Add when scorbunny cmd is done and the exit code == 0
--               then exit the window
-- TODO(patrik): Explore code folding
--               https://alpha2phi.medium.com/neovim-for-beginners-code-folding-7574925412ea
-- TODO(patrik): Explore
--   https://github.com/kosayoda/nvim-lightbulb
--	 https://github.com/nvim-treesitter/nvim-treesitter-textobjects
--	 https://github.com/tpope/vim-fugitive
--   https://github.com/tpope/vim-rhubarb
--   https://github.com/lewis6991/gitsigns.nvim
--	 https://github.com/lukas-reineke/indent-blankline.nvim

-- TODO(patrik): When sobble changes project we should have a callback so we can
--				 update nvimtree

-- TODO(patrik): Make all the Telescope dropdown
-- TODO(patrik): Fix the null_ls formatting default inside lsp_on_attach
-- TODO(patrik): Make a tool to handle projects.json
-- TODO(patrik): Inside sobble create subprojects of a projects
--				 So we can load subproejcts into tabs
-- TODO(patrik): Create a tool to handle projects.json

require("tokyonight").setup {
  style = "storm",
  styles = {
    comments = { italic = false },
    keywords = { italic = false },
    functions = { italic = false },
    variables = { italic = false },
  },
}

vim.cmd [[colorscheme tokyonight]]
vim.cmd [[highlight WinSeparator guifg=DarkGray]]
vim.cmd [[set winbar=%=%f\ %m%=]]

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.clipboard = "unnamedplus"
vim.opt.syntax = "on"
vim.opt.laststatus = 3

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.scrolloff = 8

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.belloff = "all"

vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"

vim.opt.guicursor = "n-v-c:"
vim.opt.cursorline = true
vim.opt.mouse = "a"

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.updatetime = 400
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.termguicolors = true

vim.g.mapleader = " "

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank { timeout = 250 } end,
  group = highlight_group,
  pattern = "*",
})

-- NOTE(patrik): Must be before LSP
require("neodev").setup {}

-- Import my LSP Config
require "lsp"

require("nvim-tree").setup()
require("fidget").setup {}

require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
  },
}

local telescope = require "telescope"

telescope.setup {
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    prompt_prefix = " > ",
    color_devicons = true,
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
}

telescope.load_extension "fzy_native"
telescope.load_extension "sobble"

local cmp = require "cmp"
local ls = require "luasnip"

cmp.setup {
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<c-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),

    ["<c-space>"] = cmp.mapping {
      i = cmp.mapping.complete {},
      c = function(
        _ --[[fallback]]
      )
        if cmp.visible() then
          if not cmp.confirm { select = true } then return end
        else
          cmp.complete()
        end
      end,
    },

    -- ["<tab>"] = false,
    ["<tab>"] = cmp.config.disable,

    -- ["<tab>"] = cmp.mapping {
    --   i = cmp.config.disable,
    --   c = function(fallback)
    --     fallback()
    --   end,
    -- },

    -- Testing
    ["<c-q>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },

  sources = {
    { name = "nvim_lsp_signature_help" },
    { name = "luasnip" },
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer", keyword_length = 5 },
  },

  snippet = {
    expand = function(args) ls.lsp_expand(args.body) end,
  },

  experimental = {
    ghost_text = true,
  },
}

require("lualine").setup {}
require("Comment").setup {}
require("focus").setup {}

require("sobble").setup {
  config_path = "~/projects.json",
}

local scorbunny = require "scorbunny"
scorbunny.setup {
  on_job_done = function()
    if scorbunny.job.exit_code ~= 0 then
      vim.notify("Job exited with code " .. scorbunny.job.exit_code, vim.log.levels.ERROR)
    end
  end,
}

vim.keymap.set({ "i", "s" }, "<c-n>", function()
  if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-p>", function()
  if ls.jumpable(-1) then ls.jump(-1) end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if ls.choice_active() then ls.change_choice(1) end
end)

local tb = require "telescope.builtin"

local function close_all_windows_in_current_tab()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local current_win = vim.api.nvim_get_current_win()
  for _, win in ipairs(wins) do
    if win ~= current_win then vim.api.nvim_win_close(win, false) end
  end
end

-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/autoload/tj.vim
local function save_and_exec()
  local type = vim.bo.filetype
  if type == "lua" or type == "vim" then
    vim.cmd [[silent! write]]
    vim.cmd [[source %]]
  end
end

vim.keymap.set("n", "<leader>ps", function()
  local search = vim.fn.input "Grep for: "
  tb.grep_string { search = search }
end)

-- TODO(patrik):
-- Telescope current_buffer_fuzzy_find
-- Telescope command_history

-- Wot
-- vim.keymap.set("x", "<leader>pp", '"_dP')

vim.keymap.set("n", "<leader>pd", tb.treesitter)
vim.keymap.set("n", "<leader>pf", tb.find_files)
vim.keymap.set("n", "<leader>pb", tb.buffers)
vim.keymap.set("n", "<leader>pp", telescope.extensions.sobble.sobble)

vim.keymap.set("n", "<leader>bb", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>br", "<cmd>NvimTreeRefresh<CR>")
vim.keymap.set("n", "<leader>bc", "<cmd>NvimTreeCollapse<CR>")

vim.keymap.set("n", "<leader>hh", tb.help_tags)
vim.keymap.set("n", "<leader>ho", tb.vim_options)

vim.keymap.set("n", "<leader>wj", "<C-w><C-j>")
vim.keymap.set("n", "<leader>wk", "<C-w><C-k>")
vim.keymap.set("n", "<leader>wl", "<C-w><C-l>")
vim.keymap.set("n", "<leader>wh", "<C-w><C-h>")
vim.keymap.set("n", "<leader>wp", "<C-w><C-p>")
vim.keymap.set("n", "<leader>wq", close_all_windows_in_current_tab)

vim.keymap.set("n", "<leader>wsv", "<cmd>vsp<CR>")
vim.keymap.set("n", "<leader>wsh", "<cmd>sp<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")

-- vim.keymap.set({ "n", "v" }, "<C-j>", "<M-}>")
-- vim.keymap.set({ "n", "v" }, "<C-k>", "<M-{>")

vim.keymap.set("n", "<leader>tt", "<cmd>tab split<CR>")
vim.keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>")
vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<CR>")
vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<CR>")
vim.keymap.set("n", "<leader>tml", "<cmd>tabmove +1<CR>")
vim.keymap.set("n", "<leader>tmh", "<cmd>tabmove -1<CR>")

vim.keymap.set("n", "<leader>xx", save_and_exec)
-- vim.keymap.set("n", "<leader>xs", "<cmd>source ~/.config/nvim/plugin/luasnip.lua<CR>");

-- TODO(patrik): Use quickfix
vim.keymap.set("n", "<leader>qq", "<cmd>copen<CR>")
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>")
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>")

vim.keymap.set("n", "<leader>gd", "<C-]>")
vim.keymap.set("n", "<leader>vds", tb.tags)

local function get_cmd()
  local override = vim.t.cmd_override
  if override then return override end

  local proj = vim.t.sobble_current_project
  if proj and proj.cmd then return proj.cmd end

  return nil
end

local function override_cmd()
  local old_cmd = get_cmd()
  if not old_cmd then old_cmd = "" end

  local cmd = vim.fn.input("Override Command: ", old_cmd)
  if string.len(cmd) > 0 then vim.t.cmd_override = cmd end
end

local function remove_override() vim.t.cmd_override = nil end

local function run_cmd()
  local cmd = get_cmd()
  if cmd then
    require("scorbunny").execute_cmd(cmd)
  else
    vim.notify("No cmd set", vim.log.levels.WARN)
  end
end

vim.keymap.set("n", "<leader>cc", run_cmd)
vim.keymap.set("n", "<leader>ca", override_cmd)
vim.keymap.set("n", "<leader>cw", require("scorbunny").open_window)
vim.keymap.set("n", "<leader>cq", require("scorbunny").kill)
vim.keymap.set("n", "<leader>cr", remove_override)
