{ config, pkgs, lib, ... }:

let
  nix-home-manager = builtins.fetchGit {
    url = "https://github.com/torgeir/nix-home-manager";
    rev = "a4dadbb20d5e41b5ba700520d04f974a18c7906e";
  };
in {

  # moar https://github.com/yuanw/nix-home/blob/main/modules/macintosh.nix

  # import sub modules
  imports = [
    ./link-home-manager-installed-apps.nix
    ./docker.nix
    ./gw.nix
    ./gpg.nix
    ./fonts.nix
    (nix-home-manager + "/modules")
  ];

  programs.t-firefox = {
    enable = true;
    package = pkgs.firefox-devedition-bin;
    extraEngines = (import ./firefox-da.nix { });
  };
  programs.t-doomemacs.enable = true;
  programs.t-nvim.enable = true;
  programs.t-terminal.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
  };
  programs.t-tmux.enable = true;
  programs.t-zoxide.enable = true;
  programs.t-shell-tooling.enable = true;
  programs.t-git = {
    enable = true;
    # gh version >2.40.0
    # https://github.com/cli/cli/issues/326
    ghPackage = pkgs.unstable.gh;
  };

  # home manager needs this
  home = {
    username = "torgeir";
    homeDirectory = "/Users/torgeir";
    stateVersion = "23.11";
  };

  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/
  home.packages = with pkgs; [
    coreutils

    openconnect

    ollama

    pkgs.unstable.yabai
    pkgs.unstable.skhd
  ];

  # TODO hardware.keyboard.zsa.enable

  home.file = let
    dotfiles = builtins.fetchGit {
      url = "https://github.com/torgeir/dotfiles";
      rev = "39c0cb7b1a9389d63fe87ef020dcb39d32f4a77d";
    };
  in {
    ".config/dotfiles".source = dotfiles;
    ".config/dotfiles".onChange = ''
      echo "Fixing swiftbar path"
      /usr/bin/defaults write com.ameba.Swiftbar PluginDirectory \
        $(/etc/profiles/per-user/torgeir/bin/readlink ~/.config/dotfiles)/swiftbar/scripts
      echo swiftbar plugin directory is $(/usr/bin/defaults read com.ameba.Swiftbar PluginDirectory)
    '';

    "Library/KeyBindings/DefaultKeyBinding.dict".source = dotfiles
      + "/DefaultKeyBinding.dict";

    ".ideavimrc".source = dotfiles + "/ideavimrc";

    ".yabairc".source = dotfiles + "/yabairc";
    ".yabairc".onChange =
      "/etc/profiles/per-user/torgeir/bin/yabai --restart-service";

    ".skhdrc".source = dotfiles + "/skhdrc";
    ".skhdrc".onChange =
      "/etc/profiles/per-user/torgeir/bin/skhd --restart-service";

    ".zsh".source = dotfiles + "/zsh/";
    ".zshrc".source = dotfiles + "/zshrc";
    ".inputrc".source = dotfiles + "/inputrc";
    ".zprofile".source = dotfiles + "/profile";
    ".p10k.zsh".source = dotfiles + "/p10k.zsh";
  };
}
