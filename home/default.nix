{ config, pkgs, lib, ... }:

let
  nix-home-manager = builtins.fetchGit {
    url = "https://github.com/torgeir/nix-home-manager";
    rev = "95d182569dd992a65e734e181d2176972b8bd17e";
  };
in {

  # TODO
  # moar https://github.com/yuanw/nix-home/blob/main/modules/macintosh.nix

  # import sub modules
  imports = [
    ./link-home-manager-installed-apps.nix
    ./docker.nix
    ./git.nix
    ./gw.nix
    ./gpg.nix
    ./fonts.nix
    ./firefox.nix
    (nix-home-manager + "/modules")
  ];

  programs.t-doomemacs.enable = true;
  programs.t-nvim.enable = true;
  programs.t-terminal.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
  };
  programs.t-zoxide.enable = true;
  programs.t-shell-tooling.enable = true;

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

    tmux
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
    ".gitconfig".source = dotfiles + "/gitconfig";
    ".tmux.conf".source = dotfiles + "/tmux.conf";
  };
}
