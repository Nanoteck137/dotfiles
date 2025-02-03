{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.system;
in {
  options = {
    nano.system = {
      enableDesktop = lib.mkEnableOption "enable desktop";
    };
  };

  config = lib.mkIf cfg.enableDesktop {
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      firefox
    ];

    services.xserver = {
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
