{self, config, pkgs, inputs, ...}: {
  imports = [
    ../common/home/tmux.nix
    ../common/home/nvim.nix
    ../common/home/zsh.nix
    ../common/home/git.nix
    ../common/home/misc.nix
  ];

  home.username = "deck";
  home.homeDirectory = "/home/deck";
  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
