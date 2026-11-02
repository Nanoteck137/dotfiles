{ self, config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.desktop;
in {
  options = {
    nano.desktop = {
      hyprland = lib.mkEnableOption "enable hyprland desktop";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.hyprland) {
    environment.systemPackages = [
      pkgs.wl-clipboard
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
      stylix.targets.waybar.addCss = false;

      services.udiskie = {
        settings = {
          # https://github.com/nix-community/home-manager/issues/632
          program_options = {
            file_manager = "${pkgs.thunar}/bin/thunar";
          };
        };
      };

      xdg.configFile."hypr/hyprtoolkit.conf".source = "${self}/configs/hypr/hyprtoolkit.conf";
      xdg.configFile."hypr/hypridle.conf".source = "${self}/configs/hypr/hypridle.conf";

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        extraConfig = (builtins.readFile "${self}/configs/hypr/hyprland.lua");
        plugins = [];
      };

      programs.waybar = {
        enable = true;
        style = (builtins.readFile "${self}/configs/waybar/style.css");

        settings.main = {
          modules-left = [
            "hyprland/workspaces"
          ];

          modules-center = [];

          modules-right = [
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "tray"
            "clock"
          ];

          "hyprland/workspaces" = {
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            all-outputs = true;
            show-special = true;
            on-click = "activate";
          };

          # "tray" = {
          #     "icon-size" = 21;
          #     "spacing" = 10;
          # };

          "pulseaudio" = {
            "format" = "{icon}  {volume}%";
            "format-muted" = "";
            "format-icons" = {
              "default" = ["" ""];
            };
            "scroll-step" = 1;
            "on-click" = "hyprctl dispatch \"hl.dsp.exec_cmd(\\\"pavucontrol\\\", { float = true, size = {\\\"(monitor_w*0.5)\\\", \\\"(monitor_h*0.5)\\\"} })\"";
          };
        };
      };

      home.packages = with pkgs; [
        wofi

        pavucontrol

        thunar
        tumbler

        hypridle
        brightnessctl

        hyprpicker
        wl-clipboard

        qimgv

        kanshi
      ];

      home.file."wallpaper.png".source = "${self}/wallpaper.png";

      xdg.configFile."wofi".source = "${self}/configs/wofi";

      xdg.configFile."kanshi/config".source = "${self}/configs/kanshi/steamdeck";

      # qt.enable = true;
      # qt.platformTheme = "gtk";
      # qt.style.name = "adwaita-dark";
      # qt.style.package = pkgs.adwaita-qt;
      #

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
