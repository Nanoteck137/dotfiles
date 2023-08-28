{config, pkgs, inputs, ...}: {
  imports = [
    ../common/home/nvim.nix
    ../common/home/tmux.nix
    ../common/home/zsh.nix
    ../common/home/git.nix
  ];

  nixpkgs.overlays = [ 
    inputs.neovim-nightly-overlay.overlay 
    inputs.nixneovimplugins.overlays.default
  ];

  home.username = "nanoteck137";
  home.homeDirectory = "/home/nanoteck137";
  home.packages = with pkgs; [
    htop
    any-nix-shell
  ];

  programs.home-manager.enable = true;

  programs.exa = {
    enable = true;
    enableAliases = true;
  };


  home.stateVersion = "23.05";
}
