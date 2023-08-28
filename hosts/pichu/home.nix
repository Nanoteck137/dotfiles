{config, pkgs, inputs, ...}: {
  imports = [
    ../common/home/nvim.nix
    ../common/home/tmux.nix
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

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
    };

    shellAliases = {
      "lg" = "${pkgs.lazygit}/bin/lazygit";
    };

    initExtra = ''
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };

  home.stateVersion = "23.05";
}
