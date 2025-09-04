{ config, pkgs, inputs, self, ... }:
let
  dwebble-cli = pkgs.writeShellScriptBin "dwebble-cli" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-cli $@
  '';

  dwebble-migrate = pkgs.writeShellScriptBin "dwebble-migrate" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-migrate $@
  '';

  sewaddle-cli = pkgs.writeShellScriptBin "sewaddle-cli" '' 
    ${inputs.sewaddle.packages.${pkgs.system}.default}/bin/sewaddle-cli --server "https://sewaddle.nanoteck137.net" --web "https://sewaddle.nanoteck137.net" $@
  '';

  watchbook-cli = pkgs.writeShellScriptBin "watchbook-cli" '' 
    ${inputs.watchbook.packages.${pkgs.system}.default}/bin/watchbook-cli --api-address "https://watchbook.nanoteck137.net" $@
  '';
in {
  imports = [ 
    inputs.sewaddle.nixosModules.default
    inputs.sewaddle.nixosModules.frontend

    inputs.dwebble.nixosModules.default
    inputs.watchbook.nixosModules.default

    inputs.kricketune.nixosModules.default
    inputs.kricketune.nixosModules.frontend
  ];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  stylix.enable = true;
  stylix.image = "${self}/wallpaper.png";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "klink";
  nano.system.enableSwap = true;

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
    # nano.home.vscode.enable = true;
    # nano.home.feh.enable = true;

    home.stateVersion = "23.05";
  };


  nano.system.enableSSH = true;
  nano.ftp.enable = true;
  nano.mullvad.enable = true;

  nano.customrproxy.enable = true;

  nano.system.enableDesktop = true;

  nano.samba = {
    enable = true;
    shares = [
      {
        name = "media";
        path = "/mnt/fastboi/media";
        type = "write";
      }

      {
        name = "storage";
        path = "/mnt/fastboi/storage";
        type = "write";
      }

      {
        name = "temp";
        path = "/mnt/fastboi/temp";
        type = "write";
      }

      {
        name = "media2";
        path = "/mnt/fastboi2/media";
        type = "write";
      }

      {
        name = "old";
        path = "/mnt/fastboi/old";
        type = "read-only";
      }
    ];
  };

  nano.system.nvidia = {
    enable = true;
  };

  fileSystems."/mnt/fastboi" = { 
    device = "/dev/disk/by-label/fastboi";
    fsType = "xfs";
  };

  fileSystems."/mnt/fastboi2" = { 
    device = "/dev/disk/by-label/fastboi2";
    fsType = "xfs";
  };

  fileSystems."/mnt/raichu-media" = {
      device = "//10.28.28.2/media";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  fileSystems."/mnt/raichu-storage" = {
      device = "//10.28.28.2/storage";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  services.xserver.desktopManager.budgie.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = false;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.defaultSession = "plasmax11";

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose

    dwebble-cli
    dwebble-migrate
    sewaddle-cli
    watchbook-cli
  ];

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  services.jellyfin.enable = true;

  services.sewaddle = {
    enable = true;
    library = "/mnt/fastboi/media/manga";
    username = "nanoteck137";
    initialPassword = "password";
    jwtSecret = "some_secret";
  };

  services.sewaddle-web = {
    enable = true;
    apiAddress = "";
  };

  services.dwebble = {
    enable = true;
    dataDir = "/mnt/fastboi/apps/dwebble";
    username = "nanoteck137";
    initialPassword = "password";
    jwtSecret = "some_secret";
    libraryDir = "/mnt/fastboi/media/music";
  };

  services.dwebble-web = {
    enable = true;
    apiAddress = "";
  };

  services.watchbook = {
    enable = true;
    username = "nanoteck137";
    initialPassword = "password";
    jwtSecret = "some_secret";
    libraryDir = "/mnt/fastboi/media/watch";
  };

  services.watchbook-web = {
    enable = true;
    apiAddress = "";
  };

  services.snapserver = {
    enable = true;

    streams.kricketune = {
      type = "pipe";
      location = "/run/snapserver/kricketune";
      sampleFormat = "48000:16:2";
      codec = "pcm";
    };

    openFirewall = true;
  };

  services.kricketune = {
    enable = true;
    dwebbleAddress = "https://dwebble.nanoteck137.net";
    apiToken = "limmm9lmbloquifngwqlgebuenpej434";
    audioOutput = "audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! filesink location=/run/snapserver/kricketune";
    extraConfig = ''
    [[ filter_sets ]]
    name = "Everything"
    filter = ""
    sort = "random"

    [[ filter_sets ]]
    name = "Good"
    filter = "hasTag(\"Good\")"
    sort = "random"

    [[ filter_sets ]]
    name = "Soundtrack"
    filter = "hasTag(\"Soundtrack\")"
    sort = "random"
    '';
  };

  services.kricketune-web = {
    enable = true;
    apiAddress = "";
  };

  services.restic = {
    backups = {
      media = {
        paths = [ 
          "/mnt/fastboi/media" 
          "/mnt/fastboi/apps/dwebble"
          "/mnt/fastboi/apps/sewaddle"
        ];
        extraBackupArgs = [ "--tag" "media" ];
        repository = "rest:http://10.28.28.2:8000";
        passwordFile = "/etc/nixos/restic-password";
        initialize = true;
        createWrapper = true;

        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      };
    };
  };

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

