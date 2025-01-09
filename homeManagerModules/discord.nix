{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.home.discord;
in {
  options = {
    nano.home.discord = {
      enable = lib.mkEnableOption "enable discord";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
