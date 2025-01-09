{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.home.vscode;
in {
  options = {
    nano.home.vscode = {
      enable = lib.mkEnableOption "enable vscode";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
    };
  };
}
