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

    # Server Stuff

    sewaddle.url = "github:nanoteck137/sewaddle";
    sewaddle.inputs.nixpkgs.follows = "nixpkgs";

    swadloon.url = "github:nanoteck137/swadloon";
    swadloon.inputs.nixpkgs.follows = "nixpkgs";

    haunter.url = "github:nanoteck137/haunter";
    haunter.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs: 
    let 
    in {
      nixosConfigurations.krokorok = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/krokorok/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nanoteck137 = import ./hosts/krokorok/home.nix;
          }
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
            home-manager.users.nanoteck137 = import ./hosts/pichu/home.nix;
          }
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
            home-manager.users.nanoteck137 = import ./hosts/zorua/home.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations.zorua.pkgs;
    };
}
