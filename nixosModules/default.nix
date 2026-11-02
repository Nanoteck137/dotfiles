{ pkgs, lib, ... }: {
  imports = [
    ./desktop

    ./system.nix
    ./nvidia.nix

    ./nvim.nix
    ./ftp.nix
    ./mullvad.nix
    ./samba.nix
    ./customrproxy.nix
  ];
}
