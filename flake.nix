{
  description = "Nix for macOS configuration";

  # format https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples
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

    # upgrade with
    #   nix flake lock --update-input nixpkgs-firefox-darwin
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    mkAlias = {
      url = "github:cdmistman/mkAlias";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

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
            # https://discourse.nixos.org/t/how-to-use-nixos-unstable-for-some-packages-only/36337
            # "https://github.com/ne9z/dotfiles-flake/blob/d3159df136294675ccea340623c7c363b3584e0d/configuration.nix"
            (final: prev: {
              unstable =
                import inputs.nixpkgs-unstable { system = prev.system; };
            })

            # https://github.com/shnarazk/flakes/blob/e21c982072c9e4ac92f6dec72ed8bc6d10c65b21/flake.nix
            # (final: prev: {
            #   alacritty-head =
            #     inputs.alacritty-head.packages.${prev.system}.default;
            # })
            (final: prev: {
              # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1468889352
              mkAlias =
                inputs.mkAlias.outputs.apps.${prev.system}.default.program;
            })

            (final: prev: {
              # https://freerangebits.com/posts/2024/01/patch-instead-of-pin/
              gnupg_plus_960877b = prev.gnupg.overrideAttrs (orig: {
                patches = (orig.patches or [ ]) ++ [
                  (prev.fetchurl {
                    url =
                      "https://github.com/gpg/gnupg/commit/960877b10f42ba664af4fb29130a3ba48141e64a.diff";
                    sha256 =
                      "0pa7rvy9i9w16njxdg6ly5nw3zwy0shv0v23l1mmi0b7jy7ldpvf";
                  })
                ];
              });
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
