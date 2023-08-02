{ self, pkgs, inputs, ... }: {
  nixpkgs.overlays = [ inputs.neovim-nightly-overlay.overlay ];

  environment.systemPackages =
    [
      pkgs.vim
    ];

  nixpkgs.config.allowUnfree = true;

  users.users.nanoteck137.home = "/Users/nanoteck137";

  services.nix-daemon.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;  # default shell on catalina

  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";
}
