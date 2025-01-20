{ config, pkgs, inputs, self, ... }: {
  imports = [];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  stylix.enable = true;
  stylix.image = "${self}/wallpaper.png";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";

  nano.system.type = "iso";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "iso";
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

    home.stateVersion = "23.05";
  };

  nano.system.enableSSH = true;
  nano.ftp.enable = true;
  nano.mullvad.enable = true;

  nano.system.enableDesktop = true;

  services.xserver.desktopManager.budgie.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = false;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.defaultSession = "plasmax11";

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

