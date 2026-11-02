{ self, config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.desktop;
in {
  options = {
    nano.desktop = {
      kde = lib.mkEnableOption "enable kde desktop";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.kde) {
    environment.systemPackages = [
    ];

    services.desktopManager.plasma6.enable = true;

    home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
      # services.udiskie = {
      #   settings = {
      #     # https://github.com/nix-community/home-manager/issues/632
      #     program_options = {
      #       file_manager = "${pkgs.thunar}/bin/thunar";
      #     };
      #   };
      # };

      home.packages = with pkgs; [];

      home.file."wallpaper.png".source = "${self}/wallpaper.png";

      # qt.enable = true;
      # qt.platformTheme = "gtk";
      # qt.style.name = "adwaita-dark";
      # qt.style.package = pkgs.adwaita-qt;

      gtk.enable = true;
      # gtk.cursorTheme.package = pkgs.simp1e-cursors;
      # gtk.cursorTheme.name = "Simp1e-Tokyo-Night-Storm";
      #
      # gtk.theme.package = pkgs.tokyo-night-gtk;
      # gtk.theme.name = "Tokyonight-Storm-BL";
      #
      # # gtk.iconTheme.package = pkgs.papirus-icon-theme;
      # # gtk.iconTheme.name = "Papirus-Dark";
      #
      gtk.iconTheme.package = pkgs.dracula-icon-theme;
      gtk.iconTheme.name = "Dracula";
    };
  };
}
