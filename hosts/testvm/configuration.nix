{ config, pkgs, inputs, ... }:
{
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

  networking.hostName = "testvm";
  networking.networkmanager.enable = true;

  fileSystems."/mnt/media" = { 
    device = "media";
    fsType = "9p";
  };

  users.users.nanoteck137 = {
    isNormalUser = true;
    description = "nanoteck137";
    initialPassword = "password";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIiL5jrSUxzAttiABU5jI7JhNuKsAdpkH6nm9k6LbjG nanoteck137"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    neofetch
    lazygit
    tmux
    cifs-utils
    file
    mullvad-vpn
  ];

  services.mullvad-vpn.enable = true;

  services.openssh = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05"; 
}
