{ inputs, pkgs, ... }: {

  environment.extraInit = ''
    export PATH=$HOME/bin:$PATH
  '';

  # install packages from nix's official package repository.
  environment.systemPackages = with pkgs; [
    git
    neovim
    nil # nix language server
    nixfmt # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-fmt#examples
  ];

  # To make this work, homebrew need to be installed manually, see
  # https://brew.sh The apps installed by homebrew are not managed by nix, and
  # not reproducible!  But on macOS, homebrew has a much larger selection of
  # apps than nixpkgs, especially for GUI apps!

  # work mac comes with brew
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    taps = [
      # "homebrew/cask-fonts"
      # "homebrew/services"
      # "homebrew/cask-versions"
    ];

    # brew install
    brews = [ ];

    # brew install --cask
    casks = [ "swiftbar" "zoom" "intellij-idea" ];

    # mac app store
    # click
    masApps = {
      amphetamine = 937984704;
      kindle = 302584613;

      # useful for debugging macos key codes
      #key-codes = 414568915;
    };
  };
}
