{ config, pkgs, inputs, ... }:
let
  sewaddleAddress = "10.28.28.9:4005";
  sewaddleWebAddress = "10.28.28.9:4006";
  dwebbleAddress = "10.28.28.9:7550";
  dwebbleFrontendAddress = "10.28.28.9:7551";
  ntfyAddress = "10.28.28.2:8080";
  syncthingAddress = "10.28.28.9:8384";
  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
in {
  imports = [ 
    ./hardware-configuration.nix
    ../common/common.nix
  ];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "testvm";
  networking.networkmanager.enable = true;

  fileSystems."/mnt/media" = { 
    device = "media";
    fsType = "virtiofs";
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

  # services.sewaddle = {
  #   enable = true;
  #   library = "/mnt/media/manga";
  # };
  #
  # services.dwebble = {
  #   enable = true;
  #   library = "/mnt/media/music";
  # };

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

  services.mopidy = {
    enable = true;
    configuration = ''
[audio]
output = audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! filesink location=/run/snapserver/mpd

[http]
#enabled = true
hostname = 0.0.0.0
#port = 6680
#zeroconf = Mopidy HTTP server on $hostname
#allowed_origins = 
#csrf_protection = true
#default_app = mopidy

[softwaremixer]
#enabled = true

[local]
media_dir = /mnt/media/music
included_file_extensions =
    .flac

[mpd]
hostname = ::

[iris]
    '';
    extensionPackages = [
      pkgs.mopidy-mpd
      pkgs.mopidy-iris
      pkgs.mopidy-local
    ];
  };

  # services.mpd = {
  #   enable = true;
  #   musicDirectory = "/mnt/media/music";
  #   extraConfig = ''
  #     audio_output {
  #       type            "fifo"
  #       name            "my pipe"
  #       path            "/run/snapserver/mpd"
  #       format          "48000:16:2"
  #       mixer_type      "software"
  #     }
  #   '';
  # };

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
          reverse_proxy ${dwebbleFrontendAddress}
        }
      '';
    };

    virtualHosts."sync.nanoteck137.net" = {
      extraConfig = ''
      	tls {
		      dns cloudflare ${secrets.cloudflareToken}
	      }

        handle {
          reverse_proxy ${syncthingAddress}
        }
      '';
    };

    # virtualHosts."mopidy.patrikmillvik.duckdns.org" = {
    #   extraConfig = ''
    #     tls {
    #       dns duckdns ${secrets.duckDnsToken}
    #     }
    #
    #     reverse_proxy :6680
    #   '';
    # };
    #
    # virtualHosts."ntfy.patrikmillvik.duckdns.org" = {
    #   extraConfig = ''
    #     tls {
    #       dns duckdns ${secrets.duckDnsToken}
    #     }
    #
    #     reverse_proxy ${ntfyAddress}
    #   '';
    # };

        # @httpget {
        #     protocol http
        #     method GET
        #     path_regexp ^/([-_a-z0-9]{0,64}$|docs/|static/)
        # }
        # redir @httpget https://{host}{uri}
  };

  networking.firewall.allowedTCPPorts = [ 443 6600 6680 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05"; 
}
