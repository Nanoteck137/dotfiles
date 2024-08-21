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

    sewaddle.url = "github:nanoteck137/sewaddle/v0.9.1";
    sewaddle.inputs.nixpkgs.follows = "nixpkgs";

    sewaddle-web.url = "github:nanoteck137/sewaddle-web/v0.9.1-3";
    sewaddle-web.inputs.nixpkgs.follows = "nixpkgs";

    dwebble.url = "github:nanoteck137/dwebble/v0.15.5";
    dwebble.inputs.nixpkgs.follows = "nixpkgs";
    
    dwebble-frontend.url = "github:nanoteck137/dwebble-frontend/v0.15.5-3";
    dwebble-frontend.inputs.nixpkgs.follows = "nixpkgs";

    crustle.url = "github:nanoteck137/crustle";
    crustle.inputs.nixpkgs.follows = "nixpkgs";

    customcaddy.url = "github:nanoteck137/customcaddy";
    # customcaddy.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs: 
    let 
    in {
      nixosConfigurations.krokorok = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit self inputs; };
        modules = [ 
          ./hosts/krokorok/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit self inputs; };
            home-manager.users.nanoteck137 = import ./hosts/krokorok/home.nix;
          }
        ];
      };

      nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./hosts/iso/configuration.nix 
        ];
      };

      nixosConfigurations.pichu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/pichu/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.nanoteck137 = import ./hosts/pichu/home.nix;
          }
        ];
      };

      nixosConfigurations.raichu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/raichu/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.nanoteck137 = import ./hosts/raichu/home.nix;
          }
        ];
      };

      nixosConfigurations.klink = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/klink/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit self inputs; };
            home-manager.users.nanoteck137 = import ./hosts/klink/home.nix;
          }
        ];
      };

      nixosConfigurations.testvm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/testvm/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit self inputs; };
            home-manager.users.nanoteck137 = import ./hosts/testvm/home.nix;
          }
        ];
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
