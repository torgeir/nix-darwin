{ config, pkgs, lib, ... }:

let
  nix-home-manager = builtins.fetchGit {
    url = "https://github.com/torgeir/nix-home-manager";
    rev = "63326c6b5e938d90f3a7ce0c3a4811c9802ef273";
  };
in {

  # TODO
  # moar https://github.com/yuanw/nix-home/blob/main/modules/macintosh.nix

  # import sub modules
  imports = [
    ./link-home-manager-installed-apps.nix
    ./autojump.nix
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./gw.nix
    ./fzf.nix
    ./gpg.nix
    ./fonts.nix
    ./firefox.nix
    ./jq.nix
    (nix-home-manager + "/modules")
  ];

  programs.t-doomemacs.enable = true;
  programs.t-nvim.enable = true;
  programs.t-terminal.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
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

    tmux
    pkgs.unstable.yabai
    pkgs.unstable.skhd
  ];

  # TODO hardware.keyboard.zsa.enable

  home.file = let
    dotfiles = builtins.fetchGit {
      url = "https://github.com/torgeir/dotfiles";
      rev = "03603c2603ae3d7baf6900ceeade04ef0488db68";
    };
  in {
    ".config/dotfiles".source = dotfiles;
    ".config/dotfiles".onChange = ''
            echo "Fixing swiftbar path"
            /usr/bin/defaults write com.ameba.Swiftbar PluginDirectory \
              $(/etc/profiles/per-user/torgeir/bin/readlink ~/.config/dotfiles)/swiftbar/scripts
      echo swiftbar plugin directory is $(/usr/bin/defaults read com.ameba.Swiftbar PluginDirectory)
    '';

    ".config/btop".source = dotfiles + "/config/btop";
    ".config/bat".source = dotfiles + "/config/bat";

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
    ".fzfrc".source = dotfiles + "/fzfrc";
    ".inputrc".source = dotfiles + "/inputrc";
    ".zprofile".source = dotfiles + "/profile";
    ".p10k.zsh".source = dotfiles + "/p10k.zsh";
    ".gitconfig".source = dotfiles + "/gitconfig";
    ".tmux.conf".source = dotfiles + "/tmux.conf";
  };
}
