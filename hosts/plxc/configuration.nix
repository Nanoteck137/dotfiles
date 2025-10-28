{ config, pkgs, inputs, self, ... }:
let
in {
  imports = [
  ];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  nano.system.type = "iso";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "plxc";

  # home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
  #   imports = [
  #     inputs.self.outputs.homeManagerModules.default
  #   ];
  #
  #   nano.home.zsh.enable = true;
  #   nano.home.nvim.enable = true;
  #   nano.home.git.enable = true;
  #   nano.home.tmux.enable = true;
  #
  #   home.stateVersion = "23.05";
  # };


  # nano.system.enableSSH = true;
  # nano.ftp.enable = true;
  # nano.mullvad.enable = true;

  # nano.customrproxy.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

