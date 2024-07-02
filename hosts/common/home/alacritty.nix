{config, pkgs, ...}:
{
  programs.alacritty = {
    enable = true;
  }; 

  home.packages = [
    (pkgs.nerdfonts.override {
      fonts = ["Noto"];
    })
  ];

  xdg.configFile.alacritty.source = ../../../configs/alacritty;
}
