{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.system;
in {
  options = {
    nano.system = {
      enableDesktop = lib.mkEnableOption "enable desktop";
      desktopType = mkOption {
        type = types.enum ["x11" "wayland"];
        description = "desktop type";
      };
    };
  };

  config = lib.mkIf cfg.enableDesktop {
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; mkMerge [
      [
        firefox
      ]

      (mkIf (cfg.desktopType == "x11") [
        xclip
      ])
    ];

    services.xserver = mkIf (cfg.desktopType == "x11") {
      enable = true;
      xkb = {
        layout = "se";
        variant = "nodeadkeys";
      };
    };

    programs._1password.enable = true;
    programs._1password-gui.enable = true;
  };
}
