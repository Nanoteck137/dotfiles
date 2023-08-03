{
  description = "Testing System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs: 
    let 
    in {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/desktop/configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nanoteck137 = import ./home.nix;
          }
        ];
      };

      darwinConfigurations.macos = nix-darwin.lib.darwinSystem {
        # system = "aarch64-darwin";
        specialArgs = { inherit self inputs; };
        modules = [ 
          ./hosts/macos/configuration.nix 
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nanoteck137 = import ./homemacos.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations.nanoteck137.pkgs;
    };
}
