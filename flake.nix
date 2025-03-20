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

    # Server Stuff

    sewaddle.url = "github:nanoteck137/sewaddle";
    dwebble.url = "github:nanoteck137/dwebble";
    kricketune.url = "github:nanoteck137/kricketune";
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
      in{
        # Normal Desktop 
        krokorok = buildSystem {
          name = "krokorok";
          hw = "amd";
        };

        bonk = buildSystem {
          name = "knok";
          hw = "intel";
        };

        # pichu = buildSystem {
        #   name = "pichu";
        # };

        # raichu = buildSystem {
        #   name = "raichu";
        # };

        # Media/Server 
        klink = buildSystem {
          name = "klink";
          hw = "intel";
        };

        # koffing = buildSystem {
        #   name = "koffing";
        # };

        testvm = buildSystem {
          name = "testvm";
          hw = "vm-intel";
        };

        vpnvm = buildSystem {
          name = "vpnvm";
          hw = "vm-intel";
        };

        rproxyvm = buildSystem {
          name = "rproxyvm";
          hw = "vm-intel";
        };

        iso = buildIso {
          name = "iso";
        };

        # iso = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs; };
        #   modules = [ 
        #     "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        #     ./hosts/iso/configuration.nix 
        #   ];
        # };
      };

      homeConfigurations.test = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        extraSpecialArgs = { inherit self inputs; };
        modules = [
          ./hosts/test/home.nix
        ];
      };

      darwinConfigurations.zorua = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self inputs; };
        modules = [ 
          ./hosts/zorua/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit self inputs; };
            home-manager.users.nanoteck137 = import ./hosts/zorua/home.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations.zorua.pkgs;
    };
}
