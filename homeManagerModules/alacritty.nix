{ self, config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.home.zsh;
in {
  options = {
    nano.home.alacritty = {
      enable = lib.mkEnableOption "enable alacritty";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
    }; 

    home.packages = [
      pkgs.nerd-fonts.noto
    ];

    xdg.configFile.alacritty.source = "${self}/configs/alacritty";
  };
}
