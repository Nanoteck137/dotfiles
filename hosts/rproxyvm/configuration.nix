{ config, pkgs, inputs, ... }:
let
  sewaddleAddress = "10.28.28.9:4005";
  sewaddleWebAddress = "10.28.28.9:4006";

  dwebbleAddress = "10.28.28.9:7550";
  dwebbleWebAddress = "10.28.28.9:7551";

  watchbookAddress = "10.28.28.9:5424";
  watchbookWebAddress = "10.28.28.9:5425";

  kricketuneAddress = "10.28.28.9:2040";
  kricketuneWebAddress = "10.28.28.9:2041";

  jellyfinAddress = "10.28.28.9:8096";
  freshrssAddress = "10.28.28.2:1337";

  sonarrAddress = "10.28.28.120:8989";
  prowlarrAddress = "10.28.28.120:9696";
  jellyseerrAddress = "10.28.28.120:5055";

  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
in {
  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "rproxyvm";
  nano.system.enableSwap = false;

  nano.system.enableSSH = true;
  # nano.ftp.enable = true;
  # nano.mullvad.enable = true;

  # services.tailscale.enable = true;
  # services.tailscale.useRoutingFeatures = "both";

  home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
    imports = [
      inputs.self.outputs.homeManagerModules.default
    ];

    nano.home.zsh.enable = true;
    nano.home.nvim.enable = true;
    nano.home.git.enable = true;
    nano.home.tmux.enable = true;

    home.stateVersion = "23.05";
  };

  services.caddy = {
    package = inputs.customcaddy.packages.x86_64-linux.default;
    enable = true;

    virtualHosts."dwebble.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare {env.CF_TOKEN}
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
		      dns cloudflare {env.CF_TOKEN}
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

    virtualHosts."watchbook.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare {env.CF_TOKEN}
	      }

        handle /api/* {
          reverse_proxy ${watchbookAddress}
        }

        handle /files/* {
          reverse_proxy ${watchbookAddress}
        }

        handle {
          reverse_proxy ${watchbookWebAddress}
        }
      '';
    };

    virtualHosts."kricketune.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare {env.CF_TOKEN}
	      }

        handle /api/* {
          reverse_proxy ${kricketuneAddress}
        }

        handle {
          reverse_proxy ${kricketuneWebAddress}
        }
      '';
    };

    virtualHosts."jellyfin.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare {env.CF_TOKEN}
	      }

        handle {
          reverse_proxy ${jellyfinAddress}
        }
      '';
    };

    virtualHosts."rss.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare {env.CF_TOKEN}
	      }

        handle {
          reverse_proxy ${freshrssAddress}
        }
      '';
    };

    virtualHosts."sonarr.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare {env.CF_TOKEN}
	      }

        handle {
          reverse_proxy ${sonarrAddress}
        }
      '';
    };

    virtualHosts."prowlarr.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare {env.CF_TOKEN}
	      }

        handle {
          reverse_proxy ${prowlarrAddress}
        }
      '';
    };

    virtualHosts."jellyseerr.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare {env.CF_TOKEN}
	      }

        handle {
          reverse_proxy ${jellyseerrAddress}
        }
      '';
    };
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = "/etc/caddy/.env";

  networking.firewall.allowedTCPPorts = [ 443 6600 6680 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05"; 
}
