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

    #webp support
    libwebp

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

    ollama

    tmux
    yabai
    skhd
  ];

  # TODO hardware.keyboard.zsa.enable

  home.file = let
    dotfiles = builtins.fetchGit {
      url = "https://github.com/torgeir/dotfiles";
      rev = "af7a13c903c46f64cce8ab139ea846b85d8f45ca";
    };
  in {
    ".config/dotfiles".source = dotfiles;
    ".config/dotfiles".onChange = ''
            echo "Fixing swiftbar path"
            /usr/bin/defaults write com.ameba.Swiftbar PluginDirectory \
              $(/etc/profiles/per-user/torgeir/bin/readlink ~/.config/dotfiles)/swiftbar/scripts
      echo swiftbar plugin directory is $(/usr/bin/defaults read com.ameba.Swiftbar PluginDirectory)
    '';

    ".config/alacritty/alacritty.toml".source = dotfiles
      + "/config/alacritty/alacritty.toml";

    ".config/btop/themes/catpuccin-mocha.theme".source = dotfiles
      + "/config/btop/themes/catpuccin-mocha.theme";

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
