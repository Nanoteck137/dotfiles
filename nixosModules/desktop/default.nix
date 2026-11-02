{ pkgs, lib, ... }: {
  imports = [
    ./desktop.nix
    ./hyprland.nix
    ./kde.nix
  ];
}
