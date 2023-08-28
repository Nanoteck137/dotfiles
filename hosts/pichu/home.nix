{config, pkgs, inputs, ...}: {
  imports = [
    ../common/home/nvim.nix
    ../common/home/tmux.nix
    ../common/home/zsh.nix
    ../common/home/git.nix
    ../common/home/misc.nix
  ];

  nixpkgs.overlays = [ 
    inputs.neovim-nightly-overlay.overlay 
    inputs.nixneovimplugins.overlays.default
  ];

  home.username = "nanoteck137";
  home.homeDirectory = "/home/nanoteck137";
  home.packages = with pkgs; [];

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
