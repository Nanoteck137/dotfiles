{config, pkgs, inputs, self, ...}:
let
  harpoon = pkgs.vimUtils.buildVimPlugin {
    name = "harpoon";
    src = pkgs.fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "harpoon";
      rev = "0378a6c428a0bed6a2781d459d7943843f374bce";
      hash = "sha256-FZQH38E02HuRPIPAog/nWM55FuBxKp8AyrEldFkoLYk=";
    };
  };
in {
  xdg.configFile.nvim.source = "${self}/configs/nvim";

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

    plugins = with pkgs; [
      vimPlugins.tokyonight-nvim

      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.telescope-fzf-native-nvim
      vimPlugins.telescope-nvim
      vimPlugins.plenary-nvim
      vimPlugins.nvim-web-devicons

      vimPlugins.nvim-lspconfig
      vimPlugins.neodev-nvim
      vimPlugins.fidget-nvim

      vimPlugins.indent-blankline-nvim
      vimPlugins.lualine-nvim
      vimPlugins.which-key-nvim

      harpoon

    #   vimPlugins.vim-sleuth
    #   vimPlugins.nui-nvim
    #
    #   vimPlugins.nvim-comment
    #   vimPlugins.todo-comments-nvim
    #   vimPlugins.trouble-nvim
    #
      vimPlugins.nvim-cmp
      vimPlugins.cmp-buffer
      vimPlugins.cmp-path
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-nvim-lsp-signature-help
      vimPlugins.luasnip
      vimPlugins.cmp_luasnip
      vimPlugins.friendly-snippets

      vimPlugins.comment-nvim
      vimPlugins.todo-comments-nvim

      vimPlugins.dressing-nvim

    #
    #   vimPlugins.null-ls-nvim
    #
    #   vimPlugins.nvim-surround
    #
    #   vimExtraPlugins.neo-tree-nvim
    #   vimExtraPlugins.Comment-nvim
    ];
  };
}
