{ config, pkgs, inputs, ... }:
let
  dwebble-cli = pkgs.writeShellScriptBin "dwebble-cli" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-cli --server "https://dwebble.nanoteck137.net" --web "https://dwebble.nanoteck137.net" $@
  '';

  sewaddle-cli = pkgs.writeShellScriptBin "sewaddle-cli" '' 
    ${inputs.sewaddle.packages.${pkgs.system}.default}/bin/sewaddle-cli --server "https://sewaddle.nanoteck137.net" --web "https://sewaddle.nanoteck137.net" $@
  '';
in {
  imports = [ 
    inputs.sewaddle.nixosModules.default
    inputs.sewaddle.nixosModules.frontend

    inputs.dwebble.nixosModules.default
    inputs.dwebble.nixosModules.dwebble-web

    inputs.kricketune.nixosModules.default
    inputs.kricketune.nixosModules.frontend
  ];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  # TODO(patrik): Move
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nano.system.username = "nanoteck137";
  nano.system.hostname = "klink";
  nano.system.enableSwap = true;

  nano.system.enableSSH = true;
  nano.ftp.enable = true;
  nano.mullvad.enable = true;

  nano.system.enableDesktop = true;

  nano.system.nvidia = {
    enable = true;
    # legacy = true;
  };

  fileSystems."/mnt/fastboi" = { 
    device = "/dev/disk/by-label/fastboi";
    fsType = "xfs";
  };

  services.xserver.desktopManager.budgie.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager

    docker-compose

    dwebble-cli
    sewaddle-cli

    # Samba
    cifs-utils
  ];

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
    library = "/mnt/fastboi/media/music";
    username = "nanoteck137";
    initialPassword = "password";
    jwtSecret = "some_secret";
  };

  services.dwebble-web = {
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
    apiToken = "tmmj86843slucd00gslhz4rancyvb7jl";
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
      # media = {
      #   paths = [ "/mnt/fastboi/media" ];
      #   extraBackupArgs = [ "--tag" "media" ];
      #   exclude = [ ".*" ];
      #   repository = "rest:http://10.28.28.2:8000";
      #   passwordFile = "/etc/nixos/restic-password";
      #   initialize = true;
      #   createWrapper = true;
      #
      #   timerConfig = {
      #     OnCalendar = "hourly";
      #     Persistent = true;
      #   };
      # };
      #
      # dwebble = {
      #   paths = [ "/mnt/fastboi/apps/dwebble" ];
      #   extraBackupArgs = [ "--tag" "dwebble" ];
      #   exclude = [ ".*" ];
      #   repository = "rest:http://10.28.28.2:8000";
      #   passwordFile = "/etc/nixos/restic-password";
      #   initialize = true;
      #   createWrapper = true;
      #
      #   timerConfig = {
      #     OnCalendar = "hourly";
      #     Persistent = true;
      #   };
      # };
      #
      # sewaddle = {
      #   paths = [ "/mnt/fastboi/apps/sewaddle" ];
      #   extraBackupArgs = [ "--tag" "sewaddle" ];
      #   exclude = [ ".*" ];
      #   repository = "rest:http://10.28.28.2:8000";
      #   passwordFile = "/etc/nixos/restic-password";
      #   initialize = true;
      #   createWrapper = true;
      #
      #   timerConfig = {
      #     OnCalendar = "hourly";
      #     Persistent = true;
      #   };
      # };
    };
  };


  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      global = {
        security = "user";
        "workgroup" = "WORKGROUP";
        "server string" = "klink";
        "netbios name" = "klink";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };

      media = {
        path = "/mnt/fastboi/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nanoteck137";
        "force group" = "users";
        "writeable" = "yes";
      };

      temp = {
        path = "/mnt/fastboi/temp";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nanoteck137";
        "force group" = "users";
        "writeable" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = true; 
    openFirewall = true;
    hostname = "klink";
  };


  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

