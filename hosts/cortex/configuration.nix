{ config, pkgs, inputs, self, ... }:
let
  dwebble-cli = pkgs.writeShellScriptBin "dwebble-cli" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-cli $@
  '';

  dwebble-migrate = pkgs.writeShellScriptBin "dwebble-migrate" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-migrate $@
  '';
in {
  imports = [
    inputs.dwebble.nixosModules.default
  ];

  nixpkgs.overlays = [ 
    # inputs.neovim-nightly-overlay.overlays.default
    inputs.nixneovimplugins.overlays.default
  ];

  nano.system.type = "iso";
  nano.system.username = "nanoteck137";
  nano.system.hostname = "cortex";

  # home-manager.users.${config.nano.system.username} = {config, pkgs, inputs, ...}: {
  #   imports = [
  #     inputs.self.outputs.homeManagerModules.default
  #   ];
  #
  #   nano.home.zsh.enable = true
  #   nano.home.nvim.enable = true;
  #   nano.home.git.enable = true;
  #   nano.home.tmux.enable = true;
  #
  #   home.stateVersion = "23.05";
  # };


  nano.system.enableSSH = true;
  # nano.ftp.enable = true;
  # nano.mullvad.enable = true;
  # networking.iproute2.enable = true

  nano.customrproxy.enable = true;

  services.dwebble = {
    enable = true;
    host = "0.0.0.0";
    username = "nanoteck137";
    initialPassword = "password";
    jwtSecret = "some_secret";
    libraryDir = "/media";
  };

  services.dwebble-web = {
    enable = true;
    apiAddress = "";
  };

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.nanoteck137.net";
      listen-http = "0.0.0.0:8473";
    };
  };

  # services.jellyfin.enable = true;

  environment.systemPackages = with pkgs; [
    dwebble-cli
    dwebble-migrate
  ];

  system.stateVersion = "23.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

