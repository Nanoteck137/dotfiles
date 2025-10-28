{ config, pkgs, lib, ... }: 
with lib; let 
  cfg = config.nano.system;
in {
  options = {
    nano.system = {
      username = mkOption{
        type = types.str;
        description = "username";
      };

      hostname = mkOption{
        type = types.str;
        description = "hostname";
      };

      enableSSH = mkEnableOption "enable ssh";
      enableSwap = mkEnableOption "enable swap";

      type = mkOption {
        type = types.enum ["plxc" "iso" "efi"];
        description = "system type";
      };
    };
  };

  config = {
    boot.loader = mkIf (cfg.type == "efi") {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking = mkMerge [
      (mkIf (cfg.type != "plxc") {
        hostName = cfg.hostname; 
        networkmanager.enable = true;
      })
      {
        # TODO(patrik): Enable firewall someday
        firewall.enable = false;
        firewall.allowPing = true;
      }
    ];

    services.openssh = mkIf cfg.enableSSH {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };

    environment.systemPackages = with pkgs; [
      git
      file
      jq
      ripgrep
      neovim 

      # TODO(patrik): Move?
      lazygit
      tmux
      rclone
    ];

    users.users = mkIf (cfg.type != "plxc") {
      ${cfg.username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; 
        initialPassword = "password";
        shell = pkgs.zsh;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIIiL5jrSUxzAttiABU5jI7JhNuKsAdpkH6nm9k6LbjG nanoteck137"
        ];
      };
    };

    time.timeZone = "Europe/Stockholm";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };

    console.keyMap = "sv-latin1";

    programs.zsh.enable = true;
    environment.shells = [ pkgs.zsh ];

    swapDevices = mkIf cfg.enableSwap [ 
      { 
        device = "/dev/disk/by-label/swap"; 
      }
    ];
  };
}
