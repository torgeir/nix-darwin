{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "torgeir";
    userEmail = "torgeir.thoresen@gmail.com";
  };
}
