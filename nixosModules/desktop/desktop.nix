{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.desktop;
in {
  options = {
    nano.desktop = {
      enable = lib.mkEnableOption "enable desktop";
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; mkMerge [
      [
        firefox
      ]

      # (mkIf (cfg.desktopType == "x11") [
      #   xclip
      # ])
    ];

    # services.xserver = mkIf (cfg.desktopType == "x11") {
    #   enable = true;
    #   xkb = {
    #     layout = "se";
    #     variant = "nodeadkeys";
    #   };
    # };

    programs._1password.enable = true;
    programs._1password-gui.enable = true;

    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      autoLogin = {
        enable = true;
        user = config.nano.system.username;
      };
    };
  };
}
