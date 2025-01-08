{
  description = "Testing System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";

    nvim-config.url = "github:nanoteck137/nvim-config";
    nvim-config.flake = false;

    # Server Stuff

    sewaddle.url = "github:nanoteck137/sewaddle";
    sewaddle.inputs.nixpkgs.follows = "nixpkgs";

    dwebble.url = "github:nanoteck137/dwebble";
    dwebble.inputs.nixpkgs.follows = "nixpkgs";
    
    kricketune.url = "github:nanoteck137/kricketune";
    # kricketune.inputs.nixpkgs.follows = "nixpkgs";

    customcaddy.url = "github:nanoteck137/customcaddy";
    # customcaddy.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs: 
    let 
    in {
      nixosConfigurations = let 
        buildSystem = { name, system ? "x86_64-linux", hw }: nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit self inputs; };
          modules = [ 
            { nixpkgs.config.allowUnfree = true; }
            ./nixosModules
            ./hardware/hw-${hw}.nix
            ./hosts/${name}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit self inputs; };
              home-manager.users.nanoteck137 = import ./hosts/${name}/home.nix;
            }
          ];
        };
      in{
        krokorok = buildSystem {
          name = "krokorok";
          hw = "amd";
        };

        # pichu = buildSystem {
        #   name = "pichu";
        # };

        # raichu = buildSystem {
        #   name = "raichu";
        # };

        klink = buildSystem {
          name = "klink";
          hw = "intel";
        };

        # koffing = buildSystem {
        #   name = "koffing";
        # };

        # testvm = buildSystem {
        #   name = "testvm";
        # };

        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ 
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./hosts/iso/configuration.nix 
          ];
        };
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
