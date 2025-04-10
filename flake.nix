{
  description = "Nix for macOS configuration";

  # format https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # upgrade with
    #   nix flake lock --update-input nixpkgs-firefox-darwin
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";

    mkAlias = {
      url = "github:cdmistman/mkAlias";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-locked.url =
      "github:NixOS/nixpkgs/1042fd8b148a9105f3c0aca3a6177fd1d9360ba5";

    nix-home-manager.url = "github:torgeir/nix-home-manager";
    dotfiles.url = "github:torgeir/dotfiles";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, nix-home-manager
    , dotfiles, ... }: {
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

              (final: prev: {
                # pkgs.unstable-locked.<something>
                unstable-locked =
                  import inputs.nixpkgs-locked { system = prev.system; };
              })

              (final: prev: {
                # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1468889352
                mkAlias =
                  inputs.mkAlias.outputs.apps.${prev.system}.default.program;
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
            home-manager.users.torgeir = import ./home;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              dotfiles = dotfiles;
              # hack around nix-home-manager causing infinite recursion
              isLinux = false;
            };
          }
        ];
      };

      #nixosModules.vm = { config, pkgs, modulesPath, ... }: {
      #  imports = [ "${modulesPath}/virtualisation/qemu-vm.nix" ];
      #  system.stateVersion = "23.11";
      #  boot.loader.systemd-boot.enable = true;
      #  boot.loader.efi.canTouchEfiVariables = true;
      #  services.getty.autologinUser = "test";
      #  users.users.test = {
      #    isNormalUser = true;
      #    extraGroups = [ "wheel" ]; # enable sudo
      #    packages = with pkgs; [ neofetch ];
      #    initialPassword = "linux";
      #  };
      #  virtualisation = {
      #    graphics = false;
      #    # vmVariant.virtualisation.graphics = false;
      #    # useNixStoreImage = true;
      #  };
      #  environment.systemPackages = [ pkgs.vim ];
      #};
      ## > nix run .#nixosConfigurations.linuxvm.config.system.build.vm
      #nixosConfigurations."linuxvm" = nixpkgs.lib.nixosSystem {
      #  system = "aarch64-linux"; # using the linux-builder
      #  specialArgs = { };
      #  modules = [
      #    self.nixosModules.vm
      #    { virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin; }
      #  ];
      #};
    };
}
