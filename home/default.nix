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

    yabai
    skhd
  ];

  home.file = let
    dotfiles = builtins.fetchGit {
      url = "https://github.com/torgeir/dotfiles";
      rev = "1f0cb57034e2a4fe5dd246e5c8f25da2602786de";
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
    ".zprofile".source = dotfiles + "/profile";
    ".p10k.zsh".source = dotfiles + "/p10k.zsh";
    ".gitconfig".source = dotfiles + "/gitconfig";
    ".inputrc".source = dotfiles + "/inputrc";
  };
}
