{ config, lib, pkgs, ... }: {

  home.packages = with pkgs; [
    # https://github.com/be5invis/Iosevka/releases
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/iosevka/default.nix
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/iosevka/variants.nix
    (pkgs.callPackage ./../pkgs/patch-nerd-fonts {
      font = pkgs.iosevka-bin.override { variant = "sgr-iosevka-etoile"; };
    })
    (pkgs.callPackage ./../pkgs/patch-nerd-fonts {
      font =
        pkgs.iosevka-bin.override { variant = "sgr-iosevka-term-curly-slab"; };
    })
  ];
}
