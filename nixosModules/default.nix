{ pkgs, lib, ... }: {
  imports = [
    ./system.nix
    ./desktop.nix
    ./nvidia.nix

    ./ftp.nix
    ./mullvad.nix
  ];
}
