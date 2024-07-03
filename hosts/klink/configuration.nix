{ config, pkgs, inputs, ... }:
let
in {
  imports = [ 
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

  services.xserver = {
    enable = true;
    xkb = {
      layout = "se";
      variant = "nodeadkeys";
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # displayManager.lightdm.enable = true;
    # windowManager.awesome.enable = true;
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

  # fileSystems."/mnt/raichu-media" = {
  #     device = "//10.28.28.2/media";
  #     fsType = "cifs";
  #     options = let
  #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #       user = "uid=1000,gid=100";
  #
  #     in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  # };

  services.mullvad-vpn.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
  
  networking.firewall.enable = false;

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

