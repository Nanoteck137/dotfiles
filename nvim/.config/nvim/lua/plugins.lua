vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'joshdick/onedark.vim'
    use 'folke/tokyonight.nvim'

    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'

    use 'nvim-treesitter/nvim-treesitter'

    use 'neovim/nvim-lspconfig'

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use 'numToStr/Comment.nvim'

    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/nvim-cmp'

    use 'saadparwaiz1/cmp_luasnip'

    use 'L3MON4D3/LuaSnip'

    use 'rhysd/committia.vim'
    use 'beauwilliams/focus.nvim'

    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    use 'kyazdani42/nvim-web-devicons'

    use {
        "X3eRo0/dired.nvim",
        requires = "MunifTanjim/nui.nvim",
    }

    use 'rcarriga/nvim-notify'

    use "~/plugins/sobble.nvim"
end)
