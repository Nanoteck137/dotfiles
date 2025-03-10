{config, pkgs, inputs, ...}: 
{
  imports = [
    # ../common/home/kitty.nix
    ../common/home/alacritty.nix
    ../common/home/tmux.nix
    ../common/home/nvim.nix
    ../common/home/zsh.nix
    ../common/home/git.nix
    ../common/home/misc.nix
  ];

  home.username = "nanoteck137";
  home.packages = with pkgs; [
    vscode
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
}
