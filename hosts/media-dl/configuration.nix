{ config, pkgs, inputs, ... }:
let
in {
  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "media-dl";
  nano.system.enableSwap = false;

  nano.system.enableSSH = true;
  # nano.ftp.enable = true;
  nano.mullvad.enable = true;

  # services.tailscale.enable = true;
  # services.tailscale.useRoutingFeatures = "both";

  home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
    imports = [
      inputs.self.outputs.homeManagerModules.default
    ];

    nano.home.zsh.enable = true;
    nano.home.nvim.enable = true;
    nano.home.git.enable = true;
    nano.home.tmux.enable = true;

    home.stateVersion = "23.05";
  };

  users.groups.media = {
    gid = 200;
  };

  fileSystems."/mnt/klink-media" = {
      device = "//10.28.28.9/media2";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=${toString config.users.groups.media}";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    serverConfig = {
      BitTorrent = {
        Session = {
          AnonymousModeEnabled = true;
        };
      };

      LegalNotice.Accepted = true;
      Preferences = {
        WebUI = {
          Username = "nanoteck137";
          Password_PBKDF2 = "@ByteArray(VacvXHKS7pL1cu8DF2FL4g==:3tEQOrc/Z+81/tSBhhTVOer1jzfI4z4cWVgChKBTeZbfTxIJXQtHpWrn7qVVSgPKXtiXbXLAxatxwBVlyN8/EA==)";
        };
        General = {
          Locale = "en";
          StatusbarExternalIPDisplayed = true;
        };
      };
    };
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        urlbase = "localhost";
        port = 9696;
        bindaddress = "*";
      };
    };
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    settings = {
      server = {
        urlbase = "localhost";
        port = 8989;
        bindaddress = "*";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05"; 
}
