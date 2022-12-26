local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- My theme
	use("folke/tokyonight.nvim")

	-- Plenary
	use("nvim-lua/plenary.nvim")

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		"nvim-telescope/telescope-fzy-native.nvim",
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		"jose-elias-alvarez/null-ls.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	})

	-- Autocompletion
	use({
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
	})

	-- Snippets
	use({
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
	})

	-- Editor stuff
	use({
		"rcarriga/nvim-notify",
		"kyazdani42/nvim-web-devicons",
		"nvim-lualine/lualine.nvim",
		"numToStr/Comment.nvim",
		"rhysd/committia.vim",
		"beauwilliams/focus.nvim",
		"tpope/vim-sleuth",
		"nvim-lua/popup.nvim",
		"j-hui/fidget.nvim",

		"folke/neodev.nvim",
	})

	use({
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu",
	})

	-- NVIM Tree
	use({
		"nvim-tree/nvim-tree.lua",
		tag = "nightly",
	})

	-- Languages
	use({
		"alaviss/nim.nvim",
	})

	-- My Custom Plugins
	use({
		"~/plugins/sobble.nvim",
		"~/plugins/scorbunny.nvim",
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
