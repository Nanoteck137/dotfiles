{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.samba;
in {
  options = {
    nano.samba = {
      enable = mkEnableOption "enable samba";

      shares = mkOption {
        description = "samba shares";
        type = types.listOf (types.submodule{
          options = {
            name = mkOption {
              description = "share name";
              type = types.str;
            };

            path = mkOption {
              description = "share host path";
              type = types.path;
            };

            type = mkOption {
              description = "type of share";
              type = types.enum ["read-only" "write"];
              default = "read-only";
            };
          };
        });
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.samba = let 
      global = {
        security = "user";
        "workgroup" = "WORKGROUP";
        "server string" = config.nano.system.hostname;
        "netbios name" = config.nano.system.hostname;
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
    in {
      enable = true;
      openFirewall = true;

      settings = 
        listToAttrs (
          map ( v: { 
            name = v.name; 
            value = {
              path = toString v.path;
              browseable = "yes";

              "create mask" = "0644";
              "directory mask" = "0755";

              "force user" = config.nano.system.username;
              "force group" = "users";
              "guest ok" = "no";
            } // lib.optionalAttrs (v.type == "read-only") {
              "read only" = "yes";
              "writeable" = "no";
            } // lib.optionalAttrs (v.type == "write") {
              "read only" = "no";
              "writeable" = "yes";
            }
            ; 
          } ) (cfg.shares) 
        ) // {
          inherit global;
        };
    };

    services.samba-wsdd = {
      enable = true; 
      openFirewall = true;
      hostname = "klink";
    };

    environment.systemPackages = with pkgs; [
      cifs-utils
    ];
  };
}
