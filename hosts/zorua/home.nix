{config, pkgs, ...}: 
{
  imports = [
    ../common/home/kitty.nix
    ../common/home/tmux.nix
    ../common/home/nvim.nix
  ];

  home.username = "nanoteck137";
  home.packages = with pkgs; [
    vscode
    any-nix-shell
  ];

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
      eval "$(/opt/homebrew/bin/brew shellenv)"
      any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
