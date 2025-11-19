{ config, pkgs, inputs, self, ... }:
let
in {
  imports = [ ];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  stylix.enable = true;
  stylix.image = "${self}/wallpaper.png";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
  stylix.autoEnable = true;

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "klink";
  nano.system.enableSwap = true;

  users.users."nanoteck137".extraGroups = [ "docker" ];

  home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
    imports = [
      inputs.self.outputs.homeManagerModules.default
    ];

    nano.home.zsh.enable = true;
    nano.home.alacritty.enable = true;
    nano.home.nvim.enable = true;
    nano.home.git.enable = true;
    nano.home.tmux.enable = true;

    # nano.home.discord.enable = true;
    nano.home.vscode.enable = true;
    # nano.home.feh.enable = true;

    home.stateVersion = "23.05";
  };


  nano.system.enableSSH = true;
  # nano.ftp.enable = true;
  nano.mullvad.enable = true;

  # nano.customrproxy.enable = true;

  nano.system.nvidia = {
    enable = true;
  };

  nano.system.enableDesktop = true;
  nano.system.desktopType = "wayland";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # nano.samba = {
  #   enable = true;
  #   shares = [
  #     {
  #       name = "media";
  #       path = "/mnt/fastboi/media";
  #       type = "write";
  #     }
  #
  #     {
  #       name = "storage";
  #       path = "/mnt/fastboi/storage";
  #       type = "write";
  #     }
  #
  #     {
  #       name = "temp";
  #       path = "/mnt/fastboi/temp";
  #       type = "write";
  #     }
  #
  #     {
  #       name = "media2";
  #       path = "/mnt/fastboi2/media";
  #       type = "write";
  #     }
  #
  #     {
  #       name = "old";
  #       path = "/mnt/fastboi/old";
  #       type = "read-only";
  #     }
  #   ];
  # };


  # services.xserver.desktopManager.budgie.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;

  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = false;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.defaultSession = "plasmax11";

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    kitty
    wofi
    wl-clipboard
    waybar
    kdePackages.dolphin

    # dwebble-cli
    # dwebble-migrate
    # sewaddle-cli
    # watchbook-cli
  ];

  # services.tailscale.enable = true;
  # services.tailscale.useRoutingFeatures = "both";

  # services.jellyfin.enable = true;

  # services.sewaddle = {
  #   enable = false;
  #   library = "/mnt/fastboi/media/manga";
  #   username = "nanoteck137";
  #   initialPassword = "password";
  #   jwtSecret = "some_secret";
  # };
  #
  # services.sewaddle-web = {
  #   enable = false;
  #   apiAddress = "";
  # };
  #
  # services.dwebble = {
  #   enable = true;
  #   dataDir = "/mnt/fastboi/apps/dwebble";
  #   username = "nanoteck137";
  #   initialPassword = "password";
  #   jwtSecret = "some_secret";
  #   libraryDir = "/mnt/fastboi/media/music";
  # };
  #
  # services.dwebble-web = {
  #   enable = true;
  #   apiAddress = "";
  # };
  #
  # services.watchbook = {
  #   enable = true;
  #   dataDir = "/mnt/fastboi/apps/watchbook";
  #   username = "nanoteck137";
  #   initialPassword = "password";
  #   jwtSecret = "some_secret";
  # };
  #
  # services.watchbook-web = {
  #   enable = true;
  #   apiAddress = "";
  # };
  #
  # services.snapserver = {
  #   enable = true;
  #
  #   streams.kricketune = {
  #     type = "pipe";
  #     location = "/run/snapserver/kricketune";
  #     sampleFormat = "48000:16:2";
  #     codec = "pcm";
  #   };
  #
  #   openFirewall = true;
  # };
  #
  # services.kricketune = {
  #   enable = true;
  #   dwebbleAddress = "https://dwebble.nanoteck137.net";
  #   apiToken = "limmm9lmbloquifngwqlgebuenpej434";
  #   audioOutput = "audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! filesink location=/run/snapserver/kricketune";
  #   extraConfig = ''
  #   [[ filter_sets ]]
  #   name = "Everything"
  #   filter = ""
  #   sort = "random"
  #
  #   [[ filter_sets ]]
  #   name = "Good"
  #   filter = "hasTag(\"Good\")"
  #   sort = "random"
  #
  #   [[ filter_sets ]]
  #   name = "Soundtrack"
  #   filter = "hasTag(\"Soundtrack\")"
  #   sort = "random"
  #   '';
  # };
  #
  # services.kricketune-web = {
  #   enable = true;
  #   apiAddress = "";
  # };
  #
  # services.restic = {
  #   backups = {
  #     media = {
  #       paths = [ 
  #         "/mnt/fastboi/media" 
  #         "/mnt/fastboi/apps/dwebble"
  #         "/mnt/fastboi/apps/sewaddle"
  #       ];
  #       extraBackupArgs = [ "--tag" "media" ];
  #       repository = "rest:http://10.28.28.2:8000";
  #       passwordFile = "/etc/nixos/restic-password";
  #       initialize = true;
  #       createWrapper = true;
  #
  #       timerConfig = {
  #         OnCalendar = "hourly";
  #         Persistent = true;
  #       };
  #     };
  #   };
  # };
  #
  # services.kavita = {
  #   enable = true;
  #   dataDir = "/mnt/fastboi/apps/kavita";
  #   tokenKeyFile = "/mnt/fastboi/apps/kavita/token";
  # };
  #
  # services.komga = {
  #   enable = true;
  #   stateDir = "/mnt/fastboi/apps/komga";
  #   settings = {};
  # };
  #
  # services.immich = { 
  #   enable = true;
  #   mediaLocation = "/mnt/fastboi/apps/immich";
  #   openFirewall = true;
  #   host = "0.0.0.0";
  # };
  #
  # services.ntfy-sh = {
  #   enable = true;
  #   settings = {
  #     base-url = "https://ntfy.nanoteck137.net";
  #     listen-http = "0.0.0.0:8473";
  #   };
  # };
  #
  # services.glances = {
  #   enable = true;
  #   openFirewall = true;
  # };
  #
  # services.homepage-dashboard = {
  #   enable = true;
  #   openFirewall = true;
  #   allowedHosts = "*";
  # };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
  ];

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

