{ config, pkgs, inputs, self, ... }:
let
  dwebble-cli = pkgs.writeShellScriptBin "dwebble-cli" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-cli $@
  '';

  dwebble-migrate = pkgs.writeShellScriptBin "dwebble-migrate" '' 
    ${inputs.dwebble.packages.${pkgs.system}.default}/bin/dwebble-migrate $@
  '';

  watchbook-cli = pkgs.writeShellScriptBin "watchbook-cli" '' 
    ${inputs.watchbook.packages.${pkgs.system}.default}/bin/watchbook-cli --api-address "https://watchbook.nanoteck137.net" $@
  '';
in {
  imports = [
    inputs.dwebble.nixosModules.default
    inputs.watchbook.nixosModules.default
    inputs.storebook.nixosModules.default

    inputs.kricketune.nixosModules.default
    inputs.kricketune.nixosModules.frontend
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
  nano.ftp.enable = true;
  # nano.mullvad.enable = true;
  # networking.iproute2.enable = true

  nano.customrproxy.enable = true;

  nano.samba = {
    enable = true;
    shares = [
      {
        name = "media";
        path = "/media";
        type = "write";
      }

      # {
      #   name = "storage";
      #   path = "/mnt/fastboi/storage";
      #   type = "write";
      # }
      #
      # {
      #   name = "temp";
      #   path = "/mnt/fastboi/temp";
      #   type = "write";
      # }
      #
      # {
      #   name = "media2";
      #   path = "/mnt/fastboi2/media";
      #   type = "write";
      # }
      #
      # {
      #   name = "old";
      #   path = "/mnt/fastboi/old";
      #   type = "read-only";
      # }
    ];
  };

  services.dwebble = {
    enable = true;
    username = "nanoteck137";
    initialPassword = "password";
    jwtSecret = "some_secret";
    libraryDir = "/media/music";
  };

  services.dwebble-web = {
    enable = true;
    apiAddress = "";
  };

  services.watchbook = {
    enable = true;
    username = "nanoteck137";
    initialPassword = "password";
    jwtSecret = "some_secret";
  };

  services.watchbook-web = {
    enable = true;
    apiAddress = "";
  };

  services.storebook = {
    enable = true;
    password = "password";
    jwtSecret = "some_secret";
  };

  services.storebook-web = {
    enable = true;
    apiAddress = "";
  };

  services.snapserver = {
    enable = true;

    streams.kricketune = {
      type = "pipe";
      location = "/run/snapserver/kricketune";
      sampleFormat = "48000:16:2";
      codec = "pcm";
    };

    openFirewall = true;
  };

  services.kricketune = {
    enable = true;
    dwebbleAddress = "https://dwebble.nanoteck137.net";
    apiToken = "limmm9lmbloquifngwqlgebuenpej434";
    audioOutput = "audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! filesink location=/run/snapserver/kricketune";
    extraConfig = "";
  };

  services.kricketune-web = {
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

