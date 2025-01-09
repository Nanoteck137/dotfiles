{ pkgs, lib, ... }: {
  imports = [
    ./user.nix

    ./zsh.nix
    ./nvim.nix
    ./tmux.nix
    ./git.nix
    ./alacritty.nix
    ./feh.nix
    ./vscode.nix
    ./discord.nix
  ];
}
