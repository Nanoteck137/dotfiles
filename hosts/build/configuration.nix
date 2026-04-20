{ config, pkgs, inputs, self, ... }:
let
in {
  imports = [];
  nixpkgs.overlays = [];

  nano.system.type = "iso";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "build";

  nano.system.enableSSH = true;

  environment.systemPackages = with pkgs; [];

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

