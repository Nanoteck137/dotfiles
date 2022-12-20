vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use("joshdick/onedark.vim")
	use("folke/tokyonight.nvim")

	use("nvim-treesitter/nvim-treesitter")

	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-fzy-native.nvim")

	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/nvim-cmp")

	use("saadparwaiz1/cmp_luasnip")
	use("L3MON4D3/LuaSnip")

	use("rcarriga/nvim-notify")

	use("neovim/nvim-lspconfig")

	use("kyazdani42/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")

	use("numToStr/Comment.nvim")

	use("rhysd/committia.vim")
	use("beauwilliams/focus.nvim")

	use("ziglang/zig.vim")

	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})

	use("tpope/vim-sleuth")
	use("jose-elias-alvarez/null-ls.nvim")

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})

	use("~/plugins/sobble.nvim")
	use("~/plugins/scorbunny.nvim")
end)
