{config, pkgs, inputs, ...}:
{
  xdg.configFile.nvim.source = inputs.nvim-config;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      xclip
      nodejs
      lazygit
    ];

    # plugins = with pkgs; [
    #   vimPlugins.tokyonight-nvim
    #
    #   vimPlugins.nvim-treesitter.withAllGrammars
    #   vimPlugins.telescope-nvim
    #   vimPlugins.vim-sleuth
    #   vimPlugins.telescope-fzy-native-nvim
    #   vimPlugins.nvim-web-devicons
    #   vimPlugins.nui-nvim
    #   vimPlugins.lualine-nvim
    #
    #   vimPlugins.nvim-comment
    #   vimPlugins.todo-comments-nvim
    #   vimPlugins.trouble-nvim
    #
    #   vimPlugins.nvim-cmp
    #   vimPlugins.cmp-buffer
    #   vimPlugins.cmp-path
    #   vimPlugins.cmp-nvim-lsp
    #   vimPlugins.mason-nvim
    #
    #   vimPlugins.null-ls-nvim
    #   vimPlugins.luasnip
    #
    #   vimPlugins.nvim-lspconfig
    #   vimPlugins.nvim-surround
    #
    #   vimPlugins.harpoon
    #
    #   vimExtraPlugins.neo-tree-nvim
    #   vimExtraPlugins.Comment-nvim
    # ];
  };
}
