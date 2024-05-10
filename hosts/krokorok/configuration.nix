{ config, pkgs, inputs, ... }:
let
  secrets = builtins.fromJSON (builtins.readFile /etc/nixos/secrets.json);
in {
  imports = [ 
    inputs.sewaddlenew.nixosModules.default
    ./hardware-configuration.nix
    ../common/common.nix
  ];

  nixpkgs.overlays = [ 
    inputs.neovim-nightly-overlay.overlay 
    inputs.nixneovimplugins.overlays.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "krokorok";
  networking.networkmanager.enable = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "d8817982";

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "se";
      variant = "nodeadkeys";
    };

    displayManager.lightdm.enable = true;
    windowManager.awesome.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  # hardware.pulseaudio.enable = true;
  # nixpkgs.config.pulseaudio = true;

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  virtualisation.docker.enable = true;

  services.sewaddle = {
    enable = true;
    library = "/mnt/media/manga";
  };

  # TODO(patrik): Move this
  systemd.services.memos = {
    description = "memos";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "memos";
      Group = "memos";

      StateDirectory = "memos";

      ExecStart = "${pkgs.memos}/bin/memos -d '/var/lib/memos' -m 'prod'";

      Restart = "on-failure";
      RestartSec = "5s";

      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };

  users.users = {
    memos = {
      group = "memos";
      isSystemUser = true;
    };
  };

  users.groups = {
    memos = {};
  };


  users.users.nanoteck137 = {
    isNormalUser = true;
    description = "nanoteck137";
    initialPassword = "password";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvirtd" ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIiL5jrSUxzAttiABU5jI7JhNuKsAdpkH6nm9k6LbjG nanoteck137"
    ];
  };

  nixpkgs.config.allowUnfree = true;

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
  ];

  fileSystems."/mnt/isos" = {
      device = "//10.28.28.2/isos";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  fileSystems."/mnt/media" = {
      device = "//10.28.28.2/media";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  fileSystems."/mnt/temp" = {
      device = "//10.28.28.2/temp";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ];

  services.mullvad-vpn.enable = true;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 5173 8090 3000 8081 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  services.caddy = {
    package = inputs.customcaddy.packages.x86_64-linux.default;
    enable = true;

    virtualHosts."sewaddle.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        handle /api/* {
          reverse_proxy :3000
        }

        handle /chapters/* {
          reverse_proxy :3000
        }

        handle /images/* {
          reverse_proxy :3000
        }

        handle {
          root * ${inputs.sewaddle-web.packages.x86_64-linux.default}
          try_files {path} /index.html
          file_server
        }
      '';
    };

    virtualHosts."memos.patrikmillvik.duckdns.org" = {
      extraConfig = ''
        tls {
          dns duckdns ${secrets.duckDnsToken}
        }

        reverse_proxy :8081
      '';
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05"; 
}
