{ config, pkgs, lib, osConfig, ... }: 
with lib; let 
  cfg = config.nano.ftp;

  username = osConfig.nano.system.username;
in {
  options = {
    nano.home = {};
  };

  config = {
    programs.home-manager.enable = true;
    home.username = username;
    home.homeDirectory = "/home/${username}";

    # TODO(patrik): Move
    home.packages = with pkgs; [
      htop
    ];

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
