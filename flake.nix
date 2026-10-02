{
  description = "Testing System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";

    nvim-config.url = "github:nanoteck137/nvim-config";
    nvim-config.flake = false;

    nvim.url = "github:nanoteck137/nvim.nix";

    dusk.url = "github:nanoteck137/dusk/0.1.0";
    forge.url = "github:nanoteck137/forge";

    # Server Stuff
    sewaddle.url = "github:nanoteck137/sewaddle";
    dwebble.url = "github:nanoteck137/dwebble";
    kricketune.url = "github:nanoteck137/kricketune";
    watchbook.url = "github:nanoteck137/watchbook";
    storebook.url = "github:nanoteck137/storebook";
    customcaddy.url = "github:nanoteck137/customcaddy";
  };

  outputs = { self, nixpkgs, nix-darwin, stylix, home-manager, ... }@inputs: 
    let 
    in {
      homeManagerModules.default = ./homeManagerModules;

      nixosConfigurations = let 
        buildSystem = { name, system ? "x86_64-linux", hw }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self inputs; };
          modules = [ 
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager

            { nixpkgs.config.allowUnfree = true; }
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit self inputs; };
            }

            ./nixosModules
            ./hardware/hw-${hw}.nix
            ./hosts/${name}/configuration.nix
          ];
        };

        buildIso = { name, system ? "x86_64-linux" }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self inputs; };
          modules = [ 
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager

            { nixpkgs.config.allowUnfree = true; }
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit self inputs; };
            }

            ./nixosModules
            ./hosts/${name}/configuration.nix
          ];
        };

        buildPlxc = { name, system ? "x86_64-linux" }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self inputs; };
          modules = [ 
            "${nixpkgs}/nixos/modules/virtualisation/proxmox-lxc.nix"

            { 
              proxmoxLXC.enable = true;
              proxmoxLXC.manageNetwork = true;
              nixpkgs.config.allowUnfree = true; 
            }
            # {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.extraSpecialArgs = { inherit self inputs; };
            # }

            ./nixosModules
            ./hosts/${name}/configuration.nix
          ];
        };
      in{
        klink = buildSystem {
          name = "klink";
          hw = "amd";
        };

        decky = buildSystem {
          name = "decky";
          hw = "amd";
        };

        iso = buildIso {
          name = "iso";
        };

        plxc = buildPlxc {
          name = "plxc";
        };

        cortex = buildPlxc {
          name = "cortex";
        };

        build = buildPlxc {
          name = "build";
        };
      };
    };
}
