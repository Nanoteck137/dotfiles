{ config, pkgs, inputs, ... }:
let
  sewaddle = inputs.sewaddle.packages.x86_64-linux.default.overrideAttrs (finalAttrs: previousAttrs: {
    VITE_TEST = "https://backend.sewaddle.net";
  });

  swadloon = inputs.swadloon.packages.x86_64-linux.default;

  haunter = inputs.haunter.packages.x86_64-linux.default;
  boldore = inputs.boldore.packages.x86_64-linux.default;
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

  boot.zfs.extraPools = [ "bloc" ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "ac2a5676";

  networking.hostName = "pichu"; 
  networking.networkmanager.enable = true;

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

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
    swadloon
    boldore
    zfs
  ];

  services.mullvad-vpn.enable = true;

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
        handle {
          root * ${sewaddle}
          try_files {path} /index.html
          file_server
        }
      '';
    };

    virtualHosts."backend.sewaddle.net" = {
      extraConfig = ''
        tls /etc/nixos/certs/sewaddle.net+1.pem /etc/nixos/certs/sewaddle.net+1-key.pem
        reverse_proxy http://localhost:8090
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

    virtualHosts."minioweb.services.net" = {
      extraConfig = ''
        tls /etc/nixos/certs/services.net+1.pem /etc/nixos/certs/services.net+1-key.pem
        reverse_proxy :9001
      '';
    };

    virtualHosts."stor.services.net" = {
      extraConfig = ''
        tls /etc/nixos/certs/services.net+1.pem /etc/nixos/certs/services.net+1-key.pem
        reverse_proxy :9000
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

  systemd.services.sewaddle = {
    enable = true;
    description = "Sewaddle Pocketbase Backend";

    serviceConfig = {
      Type           = "simple";
      User           = "sewaddle";
      Group          = "sewaddle";
      LimitNOFILE    = 4096;
      Restart        = "always";
      RestartSec     = "5s";
      ReadWriteDirectories = "/var/lib/sewaddle";
      StateDirectory = [ "sewaddle" ];
      LogsDirectory = [ "sewaddle" ];
      ExecStart      = "${haunter}/bin/haunter serve --dir /var/lib/sewaddle/pb_data";

      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectHome = true;
    };

    wantedBy = ["multi-user.target"];
  };

  users.users = {
    sewaddle = {
      isSystemUser = true;
      group = "sewaddle";
      home = "/var/lib/sewaddle/";
    };
  };

  users.groups = {
    sewaddle = {};
  };

  services.minio = {
    enable = true;
    region = "sv-1";
    dataDir = ["/mnt/bloc/minio"];
    # rootCredentialsFile = "";
  };

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      MIIE5zCCA0+gAwIBAgIQahX6G6OLJDq8wW7d0EduEjANBgkqhkiG9w0BAQsFADCB
      izEeMBwGA1UEChMVbWtjZXJ0IGRldmVsb3BtZW50IENBMTAwLgYDVQQLDCduYW5v
      dGVjazEzN0B6b3J1YSAoUGF0cmlrIFJvc2Vuc3Ryw7ZtICkxNzA1BgNVBAMMLm1r
      Y2VydCBuYW5vdGVjazEzN0B6b3J1YSAoUGF0cmlrIFJvc2Vuc3Ryw7ZtICkwHhcN
      MjMwODI3MjE1NDE4WhcNMzMwODI3MjE1NDE4WjCBizEeMBwGA1UEChMVbWtjZXJ0
      IGRldmVsb3BtZW50IENBMTAwLgYDVQQLDCduYW5vdGVjazEzN0B6b3J1YSAoUGF0
      cmlrIFJvc2Vuc3Ryw7ZtICkxNzA1BgNVBAMMLm1rY2VydCBuYW5vdGVjazEzN0B6
      b3J1YSAoUGF0cmlrIFJvc2Vuc3Ryw7ZtICkwggGiMA0GCSqGSIb3DQEBAQUAA4IB
      jwAwggGKAoIBgQDPZCYcjR+PTZbyL9EysyTWP8DjY1xkDK2BUieSdVMceV8D76rk
      42FglRh7WRri0x0aB0zudNsK13sKZzBoYWpITjU1PxAZvHGJbHVS4iFqCndLhzNG
      0PGHKQt924Utrosppr4uGL/WqdTsuC8NbSJJHy0WhzjzYDfM+ABmHfAyL0XViQOA
      /EtWxqkFqf54X6t6kOkDlocCpSbRBGFZjeJ3Zgj44tTWruUVJBdsASu7eBPr2U3u
      LmBX9jkaA96/oqe6FNBicIANrF/nfW32GNWVsanZ/XVXvIJUj0BSV93CCh66PLlo
      rHRX4o5WkQfjnzsfRnBrVz/wjgya8a1SLyYZZJTaHk37W6LzgX77xJv/MmaicCJK
      v/PuBXK0qeRCXE7ucy1Le2srkA/HTl9HeLYBm/9gAnAub4NpwuM47qg0ejvk9yiW
      kwWOhNdaR+HBbBuTQAFiERiDT/MvLOoXHGy68MeJzpXmANHMmGXEeEemoahgsCnX
      aermWJulrwmq1VUCAwEAAaNFMEMwDgYDVR0PAQH/BAQDAgIEMBIGA1UdEwEB/wQI
      MAYBAf8CAQAwHQYDVR0OBBYEFGuLa8z+fiPdAEJHv9qV33J8aZ4EMA0GCSqGSIb3
      DQEBCwUAA4IBgQAJD9tqfZawl7MBcIEVYwYnwV9zZTOtMMYckspdW/QVgjZxpoEb
      N9KYANFpfmuOwZUQA+dxmylGyPNRy6Jfz+jXZDOc67n3E9NY0/84eDJy0mxA9QZx
      ULnk7JCqlO4VPRa5ct24SmQI1VrleCqqwq+NDKashph7oF2YcCz5h2qvXmNVn5to
      qbrZnU8sRrR95eqnYnoeLrqBHUFdNxfYmp+IQ/55gpRfKbX+VvvmoTZT54wUU4fh
      6niXLn5nuZfMgGNrW4V84DmPtqbUQL+RoXXBieVAVIPHMojV0XUPfXh5OHAuh/PR
      0Ixjb1XqemCAODv3fTxZuuRI1MY+FBm4ZTHuKgg/t1uuD/B01gp7wlkAENAkEQfw
      xzF9mibvryOhvRo9QxWnIoeW5NhzLkLzLSoXTBXcLeMObWDaGX0rSZMunMadfurj
      jyZ2DzeVo4pRZaLD1BHQytJKq5cAchOe3UcbuMDJt8lj/jCF/6umRRSXOco+tlHo
      XSTEJihx+bNF0+8=
      -----END CERTIFICATE-----
    ''
  ];

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

  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  networking.firewall.allowedTCPPorts = [
    5357 # wsdd
  ];
  networking.firewall.allowedUDPPorts = [
    3702 # wsdd
  ];

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;

    extraConfig = ''
      workgroup = WORKGROUP
      server string = pichu
      netbios name = pichu
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
      public = {
        path = "/mnt/bloc/test";
        browseable = "yes";
        "read only" = "no";
        # "public" = "yes";
        "writeable" = "no";
        "write list" = "nanoteck137";
        "read list" = "";
        # "force user" = "nanoteck137";
        # "force group" = "users";
      };
    };
  };

}

