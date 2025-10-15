{ self, pkgs, inputs, ... }: {
  nixpkgs.overlays = [ 
    inputs.nixneovimplugins.overlays.default 
    inputs.neovim-nightly-overlay.overlays.default 
  ];

  environment.systemPackages = [
    pkgs.vim
  ];

  nixpkgs.config.allowUnfree = true;

  users.users.nanoteck137.home = "/Users/nanoteck137";

  # services.nix-daemon.enable = true;

  programs.zsh.enable = true;  # default shell on catalina

  system.configurationRevision = self.rev or self.dirtyRev or null;
  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
