{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.home.feh;
in {
  options = {
    nano.home.feh = {
      enable = lib.mkEnableOption "enable feh";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.feh = {
      enable = true;
    };
  };
}
