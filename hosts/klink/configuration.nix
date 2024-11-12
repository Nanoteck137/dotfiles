{ config, pkgs, inputs, ... }:
let
  dwebbleImport = pkgs.writeShellScriptBin "dwebble-import" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-import $@
  '';

  dwebbleDl = pkgs.writeShellScriptBin "dwebble-dl" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-dl $@
  '';
in {
  imports = [ 
    inputs.sewaddle.nixosModules.default
    inputs.sewaddle.nixosModules.frontend

    inputs.dwebble.nixosModules.default
    inputs.dwebble.nixosModules.dwebble-web
    # inputs.dwebble-frontend.nixosModules.default
    ./hardware-configuration.nix
    ../common/common.nix
  ];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "klink"; 
  networking.networkmanager.enable = true;

  fileSystems."/mnt/fastboi" = { 
    device = "/dev/disk/by-label/fastboi";
    fsType = "xfs";
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "se";
      variant = "nodeadkeys";
    };

    desktopManager.budgie.enable = true;
    displayManager.lightdm.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  virtualisation.docker.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;

  users.users.nanoteck137 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    packages = with pkgs; [];
    initialPassword = "password";
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIiL5jrSUxzAttiABU5jI7JhNuKsAdpkH6nm9k6LbjG nanoteck137"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  environment.systemPackages = with pkgs; [
    git
    neofetch
    lazygit
    tmux
    firefox
    virt-manager
    cifs-utils
    file
    mullvad-vpn
    docker-compose
    dwebbleImport
    dwebbleDl
  ];

  services.mullvad-vpn.enable = true;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.snapserver = {
    enable = true;

    streams.test = {
      type = "pipe";
      location = "/run/snapserver/mpd";
      sampleFormat = "48000:16:2";
      codec = "pcm";
    };

    openFirewall = true;
  };

  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type            "fifo"
        name            "snapinfo fifo"
        path            "/run/snapserver/mpd"
        format          "48000:16:2"
        mixer_type      "software"
      }
    '';
  };

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

  services.restic = {
    backups = {
      media = {
        paths = [ "/mnt/fastboi/media" ];
        extraBackupArgs = [ "--tag" "media" ];
        exclude = [ ".*" ];
        repository = "rest:http://10.28.28.2:8000";
        passwordFile = "/etc/nixos/restic-password";
        initialize = true;
        createWrapper = true;

        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      };

      dwebble = {
        paths = [ "/mnt/fastboi/apps/dwebble" ];
        extraBackupArgs = [ "--tag" "dwebble" ];
        exclude = [ ".*" ];
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

  services.vsftpd = {
    enable = true;
    userlist = ["nanoteck137"];
    userlistEnable = true;
    localUsers = true;
    writeEnable = true;
    extraConfig = ''
      local_umask=033
    '';
  };

  services.samba = {
    enable = true;
    securityType = "user";
    # openFirewall = true;

    extraConfig = ''
      workgroup = WORKGROUP
      server string = klink
      netbios name = klink
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      # hosts allow = 192.168.0. 127.0.0.1 localhost
      # hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';

    shares = {
      media = {
        path = "/mnt/fastboi/media";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nanoteck137";
        "force group" = "users";
        "writeable" = "no";
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
    # openFirewall = true;
    hostname = "klink";
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
  };
  
  networking.firewall.enable = false;
  networking.firewall.allowPing = true;

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

