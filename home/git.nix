{ config, lib, pkgs, ... }: {

  programs.git = {
    enable = true;
    userName = "torgeir";
    userEmail = "torgeir.thoresen@gmail.com";
  };

  home.packages = with pkgs; [
    # gh version >2.40.0
    # https://github.com/cli/cli/issues/326
    pkgs.unstable.gh
    delta
    difftastic
  ];
}
