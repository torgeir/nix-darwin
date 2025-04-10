{ inputs, pkgs, ... }: {

  environment.extraInit = ''
    export PATH=$HOME/bin:$PATH
  '';

  # install packages from nix's official package repository.
  environment.systemPackages = with pkgs; [
    git
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

    taps = [ "CtrlSpice/homebrew-otel-desktop-viewer" ];

    # brew install
    brews = [ "otel-desktop-viewer" ];

    # brew install --cask
    # these need to be updated manually
    casks = [ "swiftbar" "spotify" "zoom" "intellij-idea" ];

    # mac app store
    # click
    masApps = {
      amphetamine = 937984704;
      kindle = 302584613;
      tailscale = 1475387142;
      windows-app = 1295203466; # rdp

      # useful for debugging macos key codes
      #key-codes = 414568915;
    };
  };
}
