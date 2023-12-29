{ inputs, pkgs, ... }: {

  # TODO
  # moar https://github.com/yuanw/nix-home/blob/main/modules/macintosh.nix

  # import sub modules
  imports = [
    # ./copy-home-manager-symlinked-apps.nix
    ./autojump.nix
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./emacs.nix
    ./fonts.nix
    ./firefox.nix
    ./jq.nix
  ];

  # home manager needs this
  home = {
    username = "torgeir";
    homeDirectory = "/Users/torgeir";
    stateVersion = "23.11";
  };

  # make home manager manage it self
  programs.home-manager.enable = true;

  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/
  home.packages = with pkgs; [
    coreutils

    (ripgrep.override { withPCRE2 = true; })
    eza

    htop
    watch

    tmux
    yabai
    skhd
  ];

  home.file = let
    dotfiles = builtins.fetchGit {
      url = "https://github.com/torgeir/dotfiles";
      rev = "04ed02e76eebd4c99a13bd26881479d79e046d8b";
    };
  in {
    ".config/dotfiles".source = dotfiles;

    ".config/alacritty/alacritty.yml".source = dotfiles
      + "/config/alacritty/alacritty.yml";

    "Library/KeyBindings/DefaultKeyBinding.dict".source = dotfiles
      + "/DefaultKeyBinding.dict";

    ".yabairc".source = dotfiles + "/yabairc";
    ".skhdrc".source = dotfiles + "/skhdrc";

    ".zsh".source = dotfiles + "/zsh/";
    ".zshrc".source = dotfiles + "/zshrc";
    ".inputrc".source = dotfiles + "/inputrc";
    ".zprofile".source = dotfiles + "/profile";
    ".p10k.zsh".source = dotfiles + "/p10k.zsh";
    ".gitconfig".source = dotfiles + "/gitconfig";
    ".tmux.conf".source = dotfiles + "/tmux.conf";
  };
}
