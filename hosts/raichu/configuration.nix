{ config, lib, pkgs, inputs, ... }: 
let
  sewaddle = inputs.sewaddle.packages.x86_64-linux.default.overrideAttrs (finalAttrs: previousAttrs: {
    VITE_POCKETBASE_BASE_URL = "";
  });

  budew = inputs.swadloon.packages.x86_64-linux.budew;

  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
in {
  imports = [ 
    ./hardware-configuration.nix
    ../common/common.nix
    ../sewaddle.nix
  ];

  nixpkgs.overlays = [ 
    inputs.neovim-nightly-overlay.overlay 
    inputs.nixneovimplugins.overlays.default
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_250GB_S2R6NX0J900485J";

  networking.hostName = "raichu";
  networking.networkmanager.enable = true;

  boot.supportedFilesystems = [ "zfs" "xfs" ];
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

  services.mullvad-vpn.enable = true;

  services.caddy = {
    package = inputs.customcaddy.packages.x86_64-linux.default;
    enable = true;

    # virtualHosts."patrikmillvik.duckdns.org" = {
    #   extraConfig = ''
    #     tls {
    #       dns duckdns ${secrets.duckDnsToken}
    #     }
    #
    #     handle /api/* {
    #       reverse_proxy http://localhost:8090
    #     }
    #
    #     handle_path /admin/* {
    #       rewrite /* /_/{uri}
    #       reverse_proxy http://localhost:8090
    #     }
    #
    #     handle {
    #       root * ${sewaddle}
    #       try_files {path} /index.html
    #       file_server
    #     }
    #   '';
    # };

    virtualHosts."dbadmin.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :8081
      '';
    };

    virtualHosts."test.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :3000
      '';
    };

    virtualHosts."test2.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :8080
      '';
    };

    virtualHosts."portainer.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :9443 {
          transport http {
            tls_insecure_skip_verify
          }
        }
      '';
    };

    virtualHosts."reg.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy /v2/* http://localhost:1337 {
          header_up X-Forwarded-Proto "https"
        }

        reverse_proxy :1337
      '';
    };

    virtualHosts."dev.sewaddle.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :3000
      '';
    };

    virtualHosts."sewaddle.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :3050
      '';
    };

    virtualHosts."navidrome.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :4533
      '';
    };

    virtualHosts."memos.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :5230
      '';
    };
  };

  services.openssh.enable = true;

  # services.home-assistant = {
  #   enable = true;
  #   openFirewall = true;
  #   package = (pkgs.home-assistant.override {
  #     extraComponents = [
  #       "default_config"
  #       "met"
  #       "esphome"
  #       "mobile_app"
  #       "feedreader"
  #       "smhi"
  #     ];
  #   });
  #   config = {
  #     homeassistant = {
  #       name = "Home";
  #       unit_system = "metric";
  #       time_zone = "UTC";
  #     };
  #     frontend = {
  #       themes = "!include_dir_merge_named themes";
  #     };
  #     http = {};
  #     feedreader = {
  #       urls = [ "https://myanimelist.net/rss.php?type=rw&u=Nanoteck137" ];
  #     };
  #     mobile_app = {};
  #   };
  # };

  # services.jenkins = {
  #   enable = true;
  #   extraGroups = ["docker"];
  # };

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

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";

    daemon.settings = {
      data-root = "/mnt/fastboi/docker";
    };
  };

  virtualisation.podman = {
    enable = true;
  };

  services.guacamole-server.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf = {
    enable = true;

    # settings = {
    #   "org/virt-manager/virt-manager/connections" = {
    #     autoconnect = ["qemu:///system"];
    #     uris = ["qemu:///system"];
    #   };
    # };
  };

  environment.systemPackages = with pkgs; [
    samba
    virt-manager
    budew
    docker-compose
    rclone
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

      manga = {
        path = "/mnt/fastboi/manga";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nanoteck137";
        "force group" = "users";
        "writeable" = "yes";
      };

      music = {
        path = "/mnt/fastboi/music";
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

  services.samba-wsdd = {
    enable = true; 
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.navidrome = {
    enable = true;
    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = "/mnt/tank/media/music";
    };
  };

  services.nginx = {
    enable = true;
    additionalModules = [ pkgs.nginxModules.rtmp ];

    appendConfig = ''
      rtmp {
        server {
          listen 1935;

          application stream  {
            live on;
            record off;
            meta copy;
          }
        }
      }
    '';
  };

  systemd.services.rustdesk = {
    enable = true;
    description = "RustDesk (hbbs)";

    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type           = "simple";
      User           = "rustdesk";
      Group          = "rustdesk";
      Restart        = "always";
      RestartSec     = "5s";
      StateDirectory = [ "rustdesk" ];
      WorkingDirectory = "/var/lib/rustdesk";
      # ExecStart      = "${pkgs.rustdesk-server}/bin/hbbs -r 10.28.28.2";

      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectHome = false;
    };
    script = ''
      ${pkgs.rustdesk-server}/bin/hbbs -r 10.28.28.2
      ${pkgs.rustdesk-server}/bin/hbbr
    '';
  };

  users.users = {
    rustdesk = {
      isSystemUser = true;
      group = "rustdesk";
      home = "/var/lib/rustdesk";
    };
  };

  users.groups = {
    rustdesk = {};
  };

  services.vsftpd = {
    enable = true;
    userlist = ["nanoteck137"];
    userlistEnable = true;
    localUsers = true;
    writeEnable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 443 1935 4822 21115 21116 21117 21118 21119 ] ++ [ 9443 8080 8081 ];
  # networking.firewall.allowedUDPPorts = [ 21116 ];
  # networking.firewall.allowPing = true;
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

