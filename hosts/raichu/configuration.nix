{ config, lib, pkgs, inputs, ... }: 
let
  sewaddle = inputs.sewaddle.packages.x86_64-linux.default.overrideAttrs (finalAttrs: previousAttrs: {
    VITE_POCKETBASE_BASE_URL = "";
  });
in {
  imports = [ 
    ./hardware-configuration.nix
    ../common/common.nix
  ];

  nixpkgs.overlays = [ 
    inputs.neovim-nightly-overlay.overlay 
    inputs.nixneovimplugins.overlays.default
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S2R6NX0J900485J";

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

  services.caddy = {
    enable = true;

    virtualHosts."patrikmillvik.duckdns.org" = {
      extraConfig = ''
        file_server ${sewaddle}
      '';
    };
  };

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11";
}

