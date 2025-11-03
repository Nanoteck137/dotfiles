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

      dwebbleAddress = "10.28.28.9:7550";
      dwebbleWebAddress = "10.28.28.9:7551";

      watchbookAddress = "10.28.28.9:5424";
      watchbookWebAddress = "10.28.28.9:5425";

      kricketuneAddress = "10.28.28.9:2040";
      kricketuneWebAddress = "10.28.28.9:2041";

      jellyfinAddress = "10.28.28.9:8096";
      immichAddress = "10.28.28.41:2283";
      ntfyAddress = "127.0.0.1:8473";

      bitAddress = "10.28.28.120:8080";
      sonarrAddress = "10.28.28.120:8989";
      prowlarrAddress = "10.28.28.120:9696";
      jellyseerrAddress = "10.28.28.120:5055";
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
  };
}
