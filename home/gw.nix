{ config, lib, pkgs, ... }:

{
  home.packages = [ (pkgs.callPackage ../pkgs/gng/default.nix { }) ];
}
