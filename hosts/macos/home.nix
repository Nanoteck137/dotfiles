{config, pkgs, ...}: 
{
  home.username = "nanoteck137";
  home.packages = with pkgs; [
    vscode
    any-nix-shell
  ];

  xdg.configFile.nvim.source = ../../configs/newnvim;
  # xdg.configFile.tmux.source = ../../configs/tmux;

  programs.tmux = {
    enable = true;

    escapeTime = 1;
    prefix = "C-Space";
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    keyMode = "vi";

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # TokyoNight colors for Tmux

      set -g mode-style "fg=#7aa2f7,bg=#3b4261"

      set -g message-style "fg=#7aa2f7,bg=#3b4261"
      set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

      set -g pane-border-style "fg=#3b4261"
      set -g pane-active-border-style "fg=#7aa2f7"

      set -g status "on"
      set -g status-justify "left"

      set -g status-style "fg=#7aa2f7,bg=#1f2335"

      set -g status-left-length "100"
      set -g status-right-length "100"

      set -g status-left-style NONE
      set -g status-right-style NONE

      set -g status-left "#[fg=#1d202f,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1f2335,nobold,nounderscore,noitalics]"
      set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1d202f,bg=#7aa2f7,bold] #h "
      if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
        set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %H:%M #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1d202f,bg=#7aa2f7,bold] #h "
      }

      setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#1f2335"
      setw -g window-status-separator ""
      setw -g window-status-style "NONE,fg=#a9b1d6,bg=#1f2335"
      setw -g window-status-format "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]"
      setw -g window-status-current-format "#[fg=#1f2335,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]"

      # tmux-plugins/tmux-prefix-highlight support
      set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#1f2335]#[fg=#1f2335]#[bg=#e0af68]"
      set -g @prefix_highlight_output_suffix ""
    '';

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
      }
    ];
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
    };

    shellAliases = {
      "lg" = "${pkgs.lazygit}/bin/lazygit";
    };

    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
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
      vimPlugins.cmp-nvim-lsp

      vimPlugins.null-ls-nvim
      vimPlugins.luasnip

      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-surround

      vimExtraPlugins.neo-tree-nvim
    ];
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
