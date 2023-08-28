{ config, pkgs, inputs, ... }:
let
  sewaddle = inputs.sewaddle.packages.x86_64-linux.default.overrideAttrs (finalAttrs: previousAttrs: {
    VITE_TEST = "https://backend.sewaddle.net";
  });

  swadloon = inputs.swadloon.packages.x86_64-linux.default;
in {
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

  networking.hostName = "pichu"; 
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

  environment.systemPackages = with pkgs; [
    neovim 
    swadloon
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.caddy = {
    enable = true;
    virtualHosts."sewaddle.net" = {
      extraConfig = ''
        tls /etc/nixos/certs/sewaddle.net+1.pem /etc/nixos/certs/sewaddle.net+1-key.pem
        file_server {
          root ${sewaddle}
        }
      '';
    };
    virtualHosts."backend.sewaddle.net" = {
      extraConfig = ''
        tls /etc/nixos/certs/sewaddle.net+1.pem /etc/nixos/certs/sewaddle.net+1-key.pem
        reverse_proxy {
          to http://10.28.28.5:8090
        }
      '';
    };
    virtualHosts."ntfy.services.net" = {
      extraConfig = ''
        tls /etc/nixos/certs/services.net+1.pem /etc/nixos/certs/services.net+1-key.pem
        reverse_proxy :8080

        @httpget {
            protocol http
            method GET
            path_regexp ^/([-_a-z0-9]{0,64}$|docs/|static/)
        }
        redir @httpget https://{host}{uri}
      '';
    };
  };

  services.ntfy-sh = { 
    enable = true; 
    settings = {
      base-url = "https://ntfy.services.net";
      listen-http = ":8080";
      upstream-base-url = "https://ntfy.sh";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}

