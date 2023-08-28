{config, pkgs, inputs, ...}: {
  imports = [
    ../common/home/nvim.nix
    ../common/home/tmux.nix
    ../common/home/zsh.nix
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

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.git = {
      enable = true;
      userName  = "Patrik M. Rosenström";
      userEmail = "patrik.millvik@gmail.com";
  };

  home.stateVersion = "23.05";
}
