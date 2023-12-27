{ config, lib, pkgs, ... }:

{
  programs.autojump = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = false;
  };
}
