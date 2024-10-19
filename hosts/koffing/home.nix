{config, pkgs, inputs, self, ...}: {
  imports = [
    ../common/home/tmux.nix
    ../common/home/nvim.nix
    ../common/home/zsh.nix
    ../common/home/git.nix
    ../common/home/misc.nix
    ../common/home/alacritty.nix
  ];

  home.username = "nanoteck137";
  home.homeDirectory = "/home/nanoteck137";
  home.packages = with pkgs; [];

  programs.home-manager.enable = true;
  
  programs.vscode = {
    enable = true;
  };

  programs.feh = {
    enable = true;
  };

  xdg.configFile.awesome.source = "${self}/configs/awesome";

  # qt.enable = true;
  # qt.platformTheme = "gtk";
  # qt.style.name = "adwaita-dark";
  # qt.style.package = pkgs.adwaita-qt;

  # gtk.enable = true;
  #
  # gtk.cursorTheme.package = pkgs.simp1e-cursors;
  # gtk.cursorTheme.name = "Simp1e-Tokyo-Night-Storm";
  #
  # gtk.theme.package = pkgs.tokyo-night-gtk;
  # gtk.theme.name = "Tokyonight-Storm-BL";

  # gtk.iconTheme.package = pkgs.papirus-icon-theme;
  # gtk.iconTheme.name = "Papirus-Dark";

  # gtk.iconTheme.package = pkgs.dracula-icon-theme;
  # gtk.iconTheme.name = "Dracula";

  home.stateVersion = "23.05";
}
