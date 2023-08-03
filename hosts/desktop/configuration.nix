# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.overlays = [ 
    inputs.neovim-nightly-overlay.overlay 
    inputs.nixneovimplugins.overlays.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nanoteck137-nixos";
  networking.networkmanager.enable = true;

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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    layout = "se";
    xkbVariant = "nodeadkeys";

    displayManager.lightdm.enable = true;
    # desktopManager.gnome.enable = true;
    windowManager.awesome.enable = true;
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

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
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  users.users.nanoteck137 = {
    isNormalUser = true;
    description = "nanoteck137";
    initialPassword = "password";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvirtd" ];
    shell = pkgs.zsh;
  };

  environment.shells = [pkgs.zsh];

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
  ];

  fileSystems."/mnt/isos" = {
      device = "//10.28.28.2/isos";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        user = "uid=1000,gid=100";

      in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Noto" ]; })
  ];

  programs.zsh = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
