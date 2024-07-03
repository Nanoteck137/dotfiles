{config, pkgs, inputs, ...}: {
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

  home.stateVersion = "23.05";
}
