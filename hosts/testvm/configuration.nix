{ config, pkgs, inputs, ... }:
let
  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
in {
  imports = [ 
    inputs.sewaddlenew.nixosModules.default
    inputs.dwebble.nixosModules.default
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

  services.sewaddle = {
    enable = true;
    library = "/mnt/media/manga";
  };

  services.dwebble = {
    enable = true;
    library = "/mnt/media/music";
  };

  services.caddy = {
    package = inputs.customcaddy.packages.x86_64-linux.default;
    enable = true;

    virtualHosts."sewaddle.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        handle /api/* {
          reverse_proxy :${toString config.services.sewaddle.port}
        }

        handle /chapters/* {
          reverse_proxy :${toString config.services.sewaddle.port}
        }

        handle /images/* {
          reverse_proxy :${toString config.services.sewaddle.port}
        }

        handle {
          root * ${inputs.sewaddle-web.packages.x86_64-linux.default}
          try_files {path} /index.html
          file_server
        }
      '';
    };

    virtualHosts."dwebble.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        handle /api/* {
          reverse_proxy :${toString config.services.dwebble.port}
        }

        handle /tracks/* {
          reverse_proxy :${toString config.services.dwebble.port}
        }

        handle /images/* {
          reverse_proxy :${toString config.services.dwebble.port}
        }

        handle {
          root * ${inputs.dwebble-frontend.packages.x86_64-linux.default}
          try_files {path} /index.html
          file_server
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 7550 3000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05"; 
}
