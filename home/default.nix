{ pkgs, ... }: {

  # TODO
  # moar https://github.com/yuanw/nix-home/blob/main/modules/macintosh.nix

  # import sub modules
  imports = [
    ./link-home-manager-installed-apps.nix
    ./terminal.nix
    ./autojump.nix
    ./direnv.nix
    ./docker.nix
    ./git.nix
    ./gw.nix
    ./fzf.nix
    ./gpg.nix
    ./emacs.nix
    ./vim.nix
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

  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/
  home.packages = with pkgs; [
    coreutils

    openconnect

    # mu4e+mbsync
    mu
    isync
    msmtp

    gawk
    (ripgrep.override { withPCRE2 = true; })
    eza
    fd
    bat
    htop
    btop
    watch

    # emacs deps
    nodejs_20
    nodePackages.prettier
    nodePackages.bash-language-server
    nodePackages.ts-node
    nodePackages.typescript
    nodePackages.typescript-language-server

    tmux
    yabai
    skhd
  ];

  home.file = let
    dotfiles = builtins.fetchGit {
      url = "https://github.com/torgeir/dotfiles";
      rev = "7e24e7eeceb68ab2ec357dffa31ac673e31b1a54";
    };
  in {
    ".config/dotfiles".source = dotfiles;
    ".config/dotfiles".onChange = ''
            echo "Fixing swiftbar path"
            /usr/bin/defaults write com.ameba.Swiftbar PluginDirectory \
              $(/etc/profiles/per-user/torgeir/bin/readlink ~/.config/dotfiles)/swiftbar/scripts
      echo swiftbar plugin directory is $(/usr/bin/defaults read com.ameba.Swiftbar PluginDirectory)
    '';

    ".config/alacritty/alacritty.yml".source = dotfiles
      + "/config/alacritty/alacritty.yml";

    ".config/btop/themes/catpuccin-mocha.theme".source = dotfiles
      + "/config/btop/themes/catpuccin-mocha.theme";

    "Library/KeyBindings/DefaultKeyBinding.dict".source = dotfiles
      + "/DefaultKeyBinding.dict";

    ".ideavimrc".source = dotfiles + "/ideavimrc";

    ".yabairc".source = dotfiles + "/yabairc";
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
