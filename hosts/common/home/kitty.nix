{config, pkgs, ...}:
{
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

      map alt+left send_text all \x1b\x62
      map alt+right send_text all \x1b\x66
    '';
  }; 
}
