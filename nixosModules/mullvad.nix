{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.mullvad;
in {
  options = {
    nano.mullvad = {
      enable = lib.mkEnableOption "enable mullvad-vpn";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mullvad-vpn
    ];

    services.mullvad-vpn.enable = true;
  };
}
