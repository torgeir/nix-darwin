{ config, lib, pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "torgeir";
    userEmail = "torgeir.thoresen@gmail.com";
  };

  home.packages = with pkgs; [ gh delta difftastic ];
}
