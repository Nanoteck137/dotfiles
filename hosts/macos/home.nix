{config, pkgs, ...}: 
{
  home.username = "nanoteck137";
  home.packages = with pkgs; [
  ];

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
      # theme = "apple";
    };

    shellAliases = {
      "lg" = "${pkgs.lazygit}/bin/lazygit";
    };

    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  programs.neovim = {
   enable = true;
# package = neovim;
   defaultEditor = true;
   vimAlias = true;
   viAlias = true;
  };
  
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
