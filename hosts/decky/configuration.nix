{ config, pkgs, inputs, self, ... }:
let
in {
  imports = [ ];

  nixpkgs.overlays = [ ];

  stylix.enable = true;
  stylix.image = "${self}/wallpaper.png";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
  stylix.polarity = "dark";
  stylix.autoEnable = true;

  fonts.packages = [
    pkgs.dejavu_fonts
    pkgs.nerd-fonts.jetbrains-mono
  ];

  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };

    monospace = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };

  # stylix.fonts = {
  #   serif = {
  #     package = pkgs.nerd-fonts.jetbrains-mono;
  #     name = "JetBrains Mono Nerd Font";
  #   };
  #
  #   sansSerif = {
  #     package = pkgs.nerd-fonts.jetbrains-mono;
  #     name = "JetBrains Mono Nerd Font";
  #   };
  #
  #   monospace = {
  #     package = pkgs.nerd-fonts.jetbrains-mono;
  #     name = "JetBrains Mono Nerd Font";
  #   };
  #
  #   emoji = {
  #     package = pkgs.noto-fonts-color-emoji;
  #     name = "Noto Color Emoji";
  #   };
  # };

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "decky";
  nano.system.enableSwap = true;

  # TODO(patrik): Add option to nano.system.userExtraGroups
  users.users.${config.nano.system.username}.extraGroups = [ "docker" "uinput" "input" ];

  home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
    imports = [
      inputs.self.outputs.homeManagerModules.default
    ];

    nano.home.zsh.enable = true;
    nano.home.alacritty.enable = true;
    # nano.home.nvim.enable = true;
    nano.home.git.enable = true;
    nano.home.tmux.enable = true;

    # nano.home.discord.enable = true;
    # nano.home.vscode.enable = true;
    # nano.home.feh.enable = true;

    stylix.targets.vscode.enable = false;
    stylix.targets.waybar.addCss = false;
    stylix.targets.firefox.enable = false;

    # TODO(patrik): Move
    services.udiskie = {
      enable = true;
      notify = true;
      settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
          # replace with your favorite file manager
          file_manager = "${pkgs.thunar}/bin/thunar";
        };
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    xdg.configFile."fastfetch/config.jsonc".source = "${self}/configs/fastfetch/config.jsonc";

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

      # CAD / 3D Printing
      freecad
      prusa-slicer

      # My Custom Stuff
      inputs.dusk.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.forge.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    home.file."wallpaper.png".source = "${self}/wallpaper.png";

    xdg.configFile."wofi".source = "${self}/configs/wofi";

    xdg.configFile."kanshi/config".source = "${self}/configs/kanshi/steamdeck";

    # TODO(patrik): Move
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

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

    home.stateVersion = "23.05";
  };


  nano.system.enableSSH = true;
  nano.nvim.enable = true;
  # nano.ftp.enable = true;
  nano.mullvad.enable = true;

  nano.system.enableDesktop = true;
  nano.system.desktopType = "wayland";
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose

    wl-clipboard

    # Markdown Renderer
    glow

    # utils
    jq
    unzip
    killall
    curl
    wget
  ];

  # USB Auto-Mounting (used for prusa-slicer)
  services.udisks2.enable = true;

  # 3D Printing
  services.octoprint = {
    enable = true;
    openFirewall = true;
  };

  services.flatpak.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  hardware.uinput.enable = true;

  # services.tailscale.enable = true;
  # services.tailscale.useRoutingFeatures = "both";

  fileSystems."/mnt/other" = {
      device = "//10.28.28.7/other";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  fileSystems."/mnt/media" = {
      device = "//10.28.28.7/media";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  # Suspend when power button is pressed, instead of shutdown
  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
  ];

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

