{config, pkgs, ...}:
{
  programs.alacritty = {
    enable = true;
  }; 

  home.packages = [
    # (pkgs.nerdfonts.override {
    #   fonts = ["Noto"];
    # })
    pkgs.nerd-fonts.noto
  ];

  xdg.configFile.alacritty.source = ../../../configs/alacritty;
}
