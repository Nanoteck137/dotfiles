{config, pkgs, inputs, ...}: {
  home.username = "nanoteck137";
  home.homeDirectory = "/home/nanoteck137";
  home.packages = with pkgs; [
    htop
    gh
    rofi
    _1password-gui
  ];

  programs.home-manager.enable = true;
  
  programs.kitty = {
    enable = true;

    font = {
      name = "NotoMono Nerd Font";
      package = pkgs.nerdfonts;
    };

    shellIntegration.enableZshIntegration = true;
    shellIntegration.mode = "no-cursor";

    extraConfig = ''
      ## name: Tokyo Night Storm
      ## license: MIT
      ## author: Folke Lemaitre
      ## upstream: https://github.com/folke/tokyonight.nvim/raw/main/extras/kitty/tokyonight_storm.conf

      background #24283b
      foreground #c0caf5
      selection_background #2e3c64
      selection_foreground #c0caf5
      url_color #73daca
      cursor #c0caf5
      cursor_text_color #24283b

      # Tabs
      active_tab_background #7aa2f7
      active_tab_foreground #1f2335
      inactive_tab_background #292e42
      inactive_tab_foreground #545c7e
      #tab_bar_background #1d202f

      # Windows
      active_border_color #7aa2f7
      inactive_border_color #292e42

      # normal
      color0 #1d202f
      color1 #f7768e
      color2 #9ece6a
      color3 #e0af68
      color4 #7aa2f7
      color5 #bb9af7
      color6 #7dcfff
      color7 #a9b1d6

      # bright
      color8 #414868
      color9 #f7768e
      color10 #9ece6a
      color11 #e0af68
      color12 #7aa2f7
      color13 #bb9af7
      color14 #7dcfff
      color15 #c0caf5

      # extended colors
      color16 #ff9e64
      color17 #db4b4b

      cursor_shape block
    '';
  };
  
  xdg.configFile.awesome.source = ./awesome;
  xdg.configFile.rofi.source = ./rofi/.config/rofi;
  xdg.configFile.nvim.source = ./newnvim;
  # xdg.configFile.picom.source = ./picom/.config/picom;

  home.file."wallpaper.png".source = ./wallpaper.png;

  services.picom = {
    enable = true;
    opacityRules = [
      "100:fullscreen"
      "95:!fullscreen"
    ];
  };

  programs.feh = {
    enable = true;
  };

  programs.git = {
      enable = true;
      userName  = "Patrik M. Rosenström";
      userEmail = "patrik.millvik@gmail.com";
  };

  programs.tmux = {
    enable = true;
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
      # theme = "apple";
    };

    shellAliases = {
      "lg" = "${pkgs.lazygit}/bin/lazygit";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  
    extraPackages = with pkgs; [
      ripgrep
      fd
      xclip
    ];

    plugins = with pkgs; [
      vimPlugins.tokyonight-nvim

      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.telescope-nvim
      vimPlugins.vim-sleuth
      vimPlugins.telescope-fzy-native-nvim
      vimPlugins.nvim-web-devicons
      vimPlugins.nui-nvim
      vimPlugins.lualine-nvim

      vimPlugins.nvim-comment
      vimPlugins.todo-comments-nvim
      vimPlugins.trouble-nvim

      vimPlugins.nvim-cmp
      vimPlugins.cmp-buffer
      vimPlugins.cmp-path

      vimExtraPlugins.neo-tree-nvim
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.stateVersion = "23.05";
}
