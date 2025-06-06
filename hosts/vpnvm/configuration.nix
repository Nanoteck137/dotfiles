{ config, pkgs, inputs, ... }:
let
in {
  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  nano.system.type = "efi";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "vpnvm";
  nano.system.enableSwap = false;

  nano.system.enableSSH = true;
  # nano.ftp.enable = true;
  # nano.mullvad.enable = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

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

  networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "23.05"; 
}
