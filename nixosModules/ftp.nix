{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.ftp;
in {
  options = {
    nano.ftp = {
      enable = lib.mkEnableOption "enable ftp";
    };
  };

  config = lib.mkIf cfg.enable {
    services.vsftpd = {
      enable = true;
      # TODO(patrik): Expose the userlist
      userlist = ["nanoteck137"];
      userlistEnable = true;
      localUsers = true;
      writeEnable = true;
      extraConfig = ''
        local_umask=033
        '';
    };
  };
}
