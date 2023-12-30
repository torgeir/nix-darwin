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

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }: {
    darwinConfigurations."bekk-mac-03257" = darwin.lib.darwinSystem {
      system = "aarch64-darwin"; # apple silicon
      specialArgs = { inherit inputs; };
      modules = [
        {
          nixpkgs.overlays = [
            # pkgs.firefox-bin
            inputs.nixpkgs-firefox-darwin.overlay

            # use selected unstable packages with pkgs.unstable.xyz
            # https://github.com/ne9z/dotfiles-flake/blob/d3159df136294675ccea340623c7c363b3584e0d/configuration.nix#L3
            (final: prev: {
              unstable =
                import inputs.nixpkgs-unstable { system = prev.system; };
            })
          ];
        }
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
