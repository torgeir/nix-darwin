{
  description = "Nix for macOS configuration";

  inputs = {
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }: {
    darwinConfigurations."bekk-mac-03257" = darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # apple silicon
      specialArgs = { inherit inputs; };
      modules = [
        # pkgs.firefox-bin
        { nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ]; }
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/apps.nix
        ./modules/host-users.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = inputs;
          home-manager.users.torgeir = import ./home;
        }
      ];
    };
  };
}
