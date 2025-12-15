{ pkgs, lib, ... }: {
  imports = [
    ./system.nix
    ./desktop.nix
    ./nvidia.nix

    ./nvim.nix
    ./ftp.nix
    ./mullvad.nix
    ./samba.nix
    ./customrproxy.nix
  ];
}
