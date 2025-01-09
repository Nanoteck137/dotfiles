{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.home.git;
in {
  options = {
    nano.home.git = {
      enable = lib.mkEnableOption "enable git";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;

      settings = {
        version = 1;
      };
    };

    programs.git = {
      enable = true;
      userName  = "Patrik M. Rosenström";
      userEmail = "patrik.millvik@gmail.com";
    };
  };
}
