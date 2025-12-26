{ config, pkgs, lib, inputs, ... }: 
with lib; let 
  cfg = config.nano.customrproxy;
in {
  options = {
    nano.customrproxy = {
      enable = lib.mkEnableOption "enable custom reverse proxy";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = let 
      sewaddleAddress = "10.28.28.9:4005";
      sewaddleWebAddress = "10.28.28.9:4006";

      dwebbleAddress = "127.0.0.1:7550";
      dwebbleWebAddress = "127.0.0.1:7551";

      watchbookAddress = "127.0.0.1:5424";
      watchbookWebAddress = "127.0.0.1:5425";

      storebookAddress = "127.0.0.1:5285";
      storebookWebAddress = "127.0.0.1:5286";

      kricketuneAddress = "127.0.0.1:2040";
      kricketuneWebAddress = "127.0.0.1:2041";

      jellyfinAddress = "10.28.28.205:8096";
      immichAddress = "10.28.28.41:2283";
      ntfyAddress = "127.0.0.1:8473";

      bitAddress = "10.28.28.253:8085";
      sonarrAddress = "10.28.28.253:8989";
      radarrAddress = "10.28.28.253:7878";
      prowlarrAddress = "10.28.28.253:9696";
      jellyseerrAddress = "10.28.28.120:5055";

      pocketidAddress = "10.28.28.59:1411";
    in {
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

      virtualHosts."storebook.nanoteck137.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CF_TOKEN}
          }

          handle /api/* {
            reverse_proxy ${storebookAddress}
          }

          handle /files/* {
            reverse_proxy ${storebookAddress}
          }

          handle {
            reverse_proxy ${storebookWebAddress}
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

      virtualHosts."immich.nanoteck137.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CF_TOKEN}
          }

          handle {
            reverse_proxy ${immichAddress}
          }
        '';
      };

      virtualHosts."ntfy.nanoteck137.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CF_TOKEN}
          }

          handle {
            reverse_proxy ${ntfyAddress}

            @httpget {
              protocol http
              method GET
              path_regexp ^/([-_a-z0-9]{0,64}$|docs/|static/)
            }

            redir @httpget https://{host}{uri}
          }
        '';
      };

      virtualHosts."bit.nanoteck137.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CF_TOKEN}
          }

          handle {
            reverse_proxy ${bitAddress}
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

      virtualHosts."radarr.nanoteck137.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CF_TOKEN}
          }

          handle {
            reverse_proxy ${radarrAddress}
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

      virtualHosts."pocketid.nanoteck137.net" = {
        extraConfig = ''
          tls {
            dns cloudflare {env.CF_TOKEN}
          }

          handle {
            reverse_proxy ${pocketidAddress}
          }
        '';
      };
    };

    systemd.services.caddy.serviceConfig.EnvironmentFile = "/etc/caddy/.env";
  };
}
