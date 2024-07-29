{ config, pkgs, inputs, ... }:
let
in {
  imports = [ 
    inputs.sewaddlenew.nixosModules.default
    inputs.dwebble.nixosModules.default
    ./hardware-configuration.nix
    ../common/common.nix
  ];

  nixpkgs.overlays = [ 
    inputs.neovim-nightly-overlay.overlay 
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
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };

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

  services.mullvad-vpn.enable = true;

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.sewaddle = {
    enable = true;
    library = "/mnt/fastboi/media/manga";
    jwtSecret = "some_secret";
  };

  services.dwebble = {
    enable = true;
    library = "/mnt/fastboi/media/music";
    jwtSecret = "some_secret";
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
    };
  };
  
  networking.firewall.enable = false;

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

