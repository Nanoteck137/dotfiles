{config, pkgs, ...}:
{
  programs.alacritty = {
    enable = true;
  }; 

  home.packages = [pkgs.nerdfonts];

  xdg.configFile.alacritty.source = ../../../configs/alacritty;
}
