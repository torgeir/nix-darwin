{ config, lib, pkgs, ... }: {

  home.packages = with pkgs.unstable-locked; [
    # https://github.com/be5invis/Iosevka/releases
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/iosevka/default.nix
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/iosevka/variants.nix
    (callPackage ./../pkgs/patch-nerd-fonts {
      font = iosevka-bin.override { variant = "Etoile"; };
    })
    (callPackage ./../pkgs/patch-nerd-fonts {
      font = iosevka-bin.override { variant = "SGr-IosevkaTermCurlySlab"; };
    })
  ];
}
