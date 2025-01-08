{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.custom.ftp;
in {
  options = {
    custom.ftp = {
      enable = lib.mkEnableOption "enable ftp";
    };
  };

  config = lib.mkIf cfg.enable {
    services.vsftpd = {
      enable = true;
      userlist = ["nanoteck137"];
      userlistEnable = true;
      localUsers = true;
      writeEnable = true;
      extraConfig = ''
        local_umask=033
        '';
    };
  }
}
