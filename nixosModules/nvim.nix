{ config, pkgs, lib, inputs, ... }: 
with lib; let 
  cfg = config.nano.nvim;
in {
  options = {
    nano.nvim = {
      enable = lib.mkEnableOption "enable nvim";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.nvim.packages.${pkgs.system}.default
      lua-language-server
    ];
  };
}
