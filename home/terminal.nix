{ config, lib, pkgs, ... }:
let alacritty = pkgs.alacritty;
in {

  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
  };
}
