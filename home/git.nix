{ config, lib, dotfiles, pkgs, ... }:

{

  # TODO
  # programs.t-git = {
  # enable = true;
  #  # gh version >2.40.0
  #  # https://github.com/cli/cli/issues/326
  #  ghPackage = pkgs.unstable.gh;
  # };
  # 
  home.packages = with pkgs; [
    # TODO git
    pkgs.unstable.gh
    delta
    difftastic
  ];

  programs.git = {
    enable = true;
    userName = "torgeir";
    userEmail = "torgeir.thoresen@gmail.com";
    package = pkgs.unstable.git;
    # settings = {
    #   user = {
    #     name = "torgeir";
    #     email = "torgeir.thoresen@gmail.com";
    #   };
    # };
  };

  home.file.".gitconfig".source = dotfiles + "/gitconfig";
}
