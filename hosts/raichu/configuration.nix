{ config, lib, pkgs, inputs, ... }: {
  imports = [ 
    ./hardware-configuration.nix
    ../common/common.nix
  ];

  nixpkgs.overlays = [ 
    inputs.neovim-nightly-overlay.overlay 
    inputs.nixneovimplugins.overlays.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "raichu";
  networking.networkmanager.enable = true;

  users.users.nanoteck137 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    packages = with pkgs; [];
    initialPassword = "password";
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIiL5jrSUxzAttiABU5jI7JhNuKsAdpkH6nm9k6LbjG nanoteck137"
    ];
  };

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11";
}

