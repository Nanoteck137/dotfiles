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
    stylix.targets.firefox.enable = false;

    # TODO(patrik): Move
    services.udiskie = {
      enable = true;
      notify = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };

    xdg.configFile."fastfetch/config.jsonc".source = "${self}/configs/fastfetch/config.jsonc";

    home.packages = with pkgs; [
      vlc

      filezilla

      # CAD / 3D Printing
      freecad
      kicad
      prusa-slicer

      # My Custom Stuff
      inputs.dusk.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.forge.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # TODO(patrik): Move
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    home.stateVersion = "23.05";
  };


  nano.system.enableSSH = true;
  nano.nvim.enable = true;
  # nano.ftp.enable = true;
  nano.mullvad.enable = true;

  nano.desktop.enable = true;
  nano.desktop.hyprland = true;
  # nano.desktop.kde = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; let 
    setupDirenvScript = pkgs.writeShellScriptBin "setup-direnv" ''
      echo "use flake" >> .envrc
      direnv allow
    '';
  in [
    setupDirenvScript

    docker-compose

    # Markdown Renderer
    glow

    # utils
    jq
    unzip
    killall
    curl
    wget
    usbutils
  ];

  # USB Auto-Mounting (used for prusa-slicer)
  services.udisks2.enable = true;

  # services.flatpak.enable = true;

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

  fileSystems."/mnt/unraid-storage" = {
      device = "//10.28.28.80/storage";
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

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="000c", GROUP="wheel", MODE="0660"
    SUBSYSTEM=="usb", ATTR{idVendor}=="2e8a", ATTR{idProduct}=="000a", GROUP="wheel", MODE="0660"
  '';

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
  ];

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

