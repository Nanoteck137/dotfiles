{config, pkgs, inputs, self, ...}:
let
  harpoon = pkgs.vimUtils.buildVimPlugin {
    name = "harpoon";
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "harpoon";
      rev = "a84ab829eaf3678b586609888ef52f7779102263";
      hash = "sha256-PjB64kdmoCD7JfUB7Qz9n34hk0h2/ZZRlN8Jv2Z9HT8=";
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

      lua-language-server
      svelte-language-server
      typescript
      typescript-language-server
      tailwindcss-language-server
    ];

    plugins = with pkgs; [
      vimPlugins.plenary-nvim
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
      vimPlugins.trouble-nvim

      vimPlugins.dressing-nvim

#   vimPlugins.null-ls-nvim
#   vimPlugins.nvim-surround
#   vimExtraPlugins.neo-tree-nvim
    ];
  };
}
