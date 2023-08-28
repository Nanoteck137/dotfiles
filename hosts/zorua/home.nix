{config, pkgs, ...}: 
{
  imports = [
    ../common/home/kitty.nix
    ../common/home/tmux.nix
    ../common/home/nvim.nix
    ../common/home/zsh.nix
    ../common/home/git.nix
  ];

  home.username = "nanoteck137";
  home.packages = with pkgs; [
    vscode
    any-nix-shell
  ];

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
