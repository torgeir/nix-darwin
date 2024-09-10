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
    nodePackages.yaml-language-server
    nodePackages.ts-node
    nodePackages.typescript
    nodePackages.typescript-language-server
    clojure-lsp
    shellcheck

    ollama

    tmux
    pkgs.unstable.yabai
    pkgs.unstable.skhd
  ];

  # TODO hardware.keyboard.zsa.enable

  home.file = let
    dotfiles = builtins.fetchGit {
      url = "https://github.com/torgeir/dotfiles";
      rev = "cee7da7a2ef276184cd7de6853289e8170035da0";
    };
  in {
    ".config/dotfiles".source = dotfiles;
    ".config/dotfiles".onChange = ''
            echo "Fixing swiftbar path"
            /usr/bin/defaults write com.ameba.Swiftbar PluginDirectory \
              $(/etc/profiles/per-user/torgeir/bin/readlink ~/.config/dotfiles)/swiftbar/scripts
      echo swiftbar plugin directory is $(/usr/bin/defaults read com.ameba.Swiftbar PluginDirectory)
    '';

    ".config/alacritty/main.toml".source = dotfiles
      + "/config/alacritty/main.toml";
    ".config/alacritty/alacritty-dark.toml".source = dotfiles
      + "/config/alacritty/alacritty-dark.toml";
    ".config/alacritty/alacritty-light.toml".source = dotfiles
      + "/config/alacritty/alacritty-light.toml";
    ".config/alacritty/catppuccin-mocha.toml".source = dotfiles
      + "/config/alacritty/catppuccin-mocha.toml";
    ".config/alacritty/catppuccin-latte.toml".source = dotfiles
      + "/config/alacritty/catppuccin-latte.toml";
    ".config/alacritty/alacritty-toggle-appearance".text = ''
      #!/usr/bin/env bash
      cd ${config.xdg.configHome}/alacritty/
      darkmode=$(osascript -e 'tell application "System Events" to get dark mode of appearance preferences')
      if [ "true" = "$darkmode" ]; then
        cp -f alacritty-dark.toml alacritty.toml
      else
        cp -f alacritty-light.toml alacritty.toml
      fi
    '';
    ".config/alacritty/alacritty-toggle-appearance".onChange = ''
      sudo chown torgeir ${config.xdg.configHome}/alacritty/alacritty-toggle-appearance
      sudo chmod u+x ${config.xdg.configHome}/alacritty/alacritty-toggle-appearance
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
    ".fzfrc".source = dotfiles + "/fzfrc";
    ".inputrc".source = dotfiles + "/inputrc";
    ".zprofile".source = dotfiles + "/profile";
    ".p10k.zsh".source = dotfiles + "/p10k.zsh";
    ".gitconfig".source = dotfiles + "/gitconfig";
    ".tmux.conf".source = dotfiles + "/tmux.conf";
  };
}
