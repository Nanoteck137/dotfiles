{ config, pkgs, inputs, ... }:
let
  sewaddleAddress = "10.28.28.9:4005";
  sewaddleWebAddress = "10.28.28.9:4006";

  dwebbleAddress = "klink:7550";
  dwebbleWebAddress = "klink:7551";

  kricketuneAddress = "10.28.28.9:2040";
  kricketuneWebAddress = "10.28.28.9:2041";

  jellyfinAddress = "10.28.28.2:8096";

  kanboardAddress = "10.28.28.2:8001";

  cockpitAddress = "10.28.28.9:9090";

  ntfyAddress = "10.28.28.2:8080";
  syncthingAddress = "10.28.28.9:8384";
  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
in {
  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "klink";
  nano.system.enableSwap = true;

  home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
    imports = [
      inputs.self.outputs.homeManagerModules.default
    ];

    nano.home.zsh.enable = true;
    nano.home.nvim.enable = true;
    nano.home.git.enable = true;
    nano.home.tmux.enable = true;

    # nano.home.discord.enable = true;
    # nano.home.vscode.enable = true;
    # nano.home.feh.enable = true;

    home.stateVersion = "23.05";
  };


  nano.system.enableSSH = true;
  nano.ftp.enable = true;
  nano.mullvad.enable = true;

  fileSystems."/mnt/media" = { 
    device = "media";
    fsType = "virtiofs";
  };

  environment.systemPackages = with pkgs; [
    mullvad-vpn
  ];

  services.mullvad-vpn.enable = true;

  services.snapserver = {
    enable = true;

    streams.test = {
      type = "pipe";
      location = "/run/snapserver/mpd";
      sampleFormat = "48000:16:2";
      codec = "pcm";
    };

    openFirewall = true;
  };

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  services.caddy = {
    package = inputs.customcaddy.packages.x86_64-linux.default;
    enable = true;

    # virtualHosts."sewaddle.patrikmillvik.duckdns.org" = {
    #   extraConfig = ''
    #     tls {
    #       dns duckdns ${secrets.duckDnsToken}
    #     }
    #
    #     handle /api/* {
    #       reverse_proxy ${sewaddleAddress}
    #     }
    #
    #     handle /files/* {
    #       reverse_proxy ${sewaddleAddress}
    #     }
    #
    #     handle {
    #       reverse_proxy ${sewaddleWebAddress}
    #     }
    #   '';
    # };
    #
    # virtualHosts."dwebble.patrikmillvik.duckdns.org" = {
    #   extraConfig = ''
    #     tls {
    #       dns duckdns ${secrets.duckDnsToken}
    #     }
    #
    #     handle /api/* {
    #       reverse_proxy ${dwebbleAddress}
    #     }
    #
    #     handle /files/* {
    #       reverse_proxy ${dwebbleAddress}
    #     }
    #
    #     handle {
    #       reverse_proxy ${dwebbleFrontendAddress}
    #     }
    #   '';
    # };



    virtualHosts."dwebble.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare ${secrets.cloudflareToken}
	      }

        handle /api/* {
          reverse_proxy ${dwebbleAddress}
        }

        handle /files/* {
          reverse_proxy ${dwebbleAddress}
        }

        handle {
          reverse_proxy ${dwebbleWebAddress}
        }
      '';
    };

    virtualHosts."sewaddle.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare ${secrets.cloudflareToken}
	      }

        handle /api/* {
          reverse_proxy ${sewaddleAddress}
        }

        handle /files/* {
          reverse_proxy ${sewaddleAddress}
        }

        handle {
          reverse_proxy ${sewaddleWebAddress}
        }
      '';
    };

    virtualHosts."kricketune.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare ${secrets.cloudflareToken}
	      }

        handle /api/* {
          reverse_proxy ${kricketuneAddress}
        }

        handle {
          reverse_proxy ${kricketuneWebAddress}
        }
      '';
    };

    virtualHosts."sync.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare ${secrets.cloudflareToken}
	      }

        handle {
          reverse_proxy ${syncthingAddress} {
            header_up Host {upstream_hostport}
          }
        }
      '';
    };

    virtualHosts."jellyfin.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare ${secrets.cloudflareToken}
	      }

        handle {
          reverse_proxy ${jellyfinAddress}
        }
      '';
    };

    virtualHosts."kanboard.nanoteck137.net" = {
      extraConfig = ''
      	tls {
          dns cloudflare ${secrets.cloudflareToken}
        }

        handle {
          reverse_proxy ${kanboardAddress}
        }
      '';
    };

    virtualHosts."cockpit.nanoteck137.net" = {
      extraConfig = ''
      	tls {
          dns cloudflare ${secrets.cloudflareToken}
        }

        handle {
          reverse_proxy ${cockpitAddress} {
            transport http {
              tls_insecure_skip_verify
            }
          }
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 6600 6680 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05"; 
}
