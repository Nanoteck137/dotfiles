{ config, lib, pkgs, inputs, ... }: 
let
  sewaddle = inputs.sewaddle.packages.x86_64-linux.default.overrideAttrs (finalAttrs: previousAttrs: {
    VITE_POCKETBASE_BASE_URL = "";
  });

  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
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

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "4efb303f";

  boot.zfs.extraPools = [ "tank" ];

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
    package = inputs.customcaddy.packages.x86_64-linux.default;
    enable = true;
  
    virtualHosts."patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        root * ${sewaddle}
        try_files {path} /index.html
        file_server
      '';
    };
  };

  services.openssh.enable = true;

  # virtualisation.oci-containers.containers = {
  #    nginxproxymanager = {
  #      image = "jc21/nginx-proxy-manager:latest";
  #      ports = [
  #        "80:80"
  #        "81:81"
  #        "443:443"
  #        "1337:1337"
  #      ];
  #    };
  # };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    samba
  ];

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;

    extraConfig = ''
      workgroup = WORKGROUP
      server string = raichu
      netbios name = raichu
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      # hosts allow = 192.168.0. 127.0.0.1 localhost
      # hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';

    shares = {
      # public = {
      #   path = "/mnt/tank/isos";
      #   browseable = "yes";
      #   "read only" = "yes";
      #   "guest ok" = "yes";
      #   "create mask" = "0644";
      #   "directory mask" = "0755";
      #   "force user" = "nanoteck137";
      #   "force group" = "users";
      # };
      isos = {
        path = "/mnt/tank/isos";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nanoteck137";
        "force group" = "users";
        "writeable" = "yes";
      };

      media = {
        path = "/mnt/tank/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nanoteck137";
        "force group" = "users";
        "writeable" = "yes";
      };

      storage = {
        path = "/mnt/tank/storage";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nanoteck137";
        "force group" = "users";
        "writeable" = "yes";
      };

      temp = {
        path = "/mnt/tank/temp";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nanoteck137";
        "force group" = "users";
        "writeable" = "yes";
      };
    };
  };

  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 5357 ];
  networking.firewall.allowedUDPPorts = [ 3702 ];
  networking.firewall.allowPing = true;
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

