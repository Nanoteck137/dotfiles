{ config, pkgs, inputs, self, ... }:
let
in {
  imports = [];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  stylix.enable = true;
  stylix.image = "${self}/wallpaper.png";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "bonk";
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

    nano.home.discord.enable = true;
    nano.home.vscode.enable = true;
    nano.home.feh.enable = true;

    home.stateVersion = "23.05";
  };

  nano.system.enableSSH = true;
  nano.ftp.enable = true;
  nano.mullvad.enable = true;

  nano.system.enableDesktop = true;

  services.xserver.desktopManager.budgie.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  nano.system.nvidia = {
    enable = true;
  };

  # fileSystems."/mnt/raichu-media" = {
  #     device = "//10.28.28.2/media";
  #     fsType = "cifs";
  #     options = let
  #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #       user = "uid=1000,gid=100";
  #
  #     in ["${automount_opts},${user},credentials=/etc/nixos/smb-secrets"];
  # };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

