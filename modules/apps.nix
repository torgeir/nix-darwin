{ inputs, pkgs, ... }: {

  environment.extraInit = ''
    export PATH=$HOME/bin:$PATH
    export PATH=$HOME/.local/bin:$PATH
    export PATH=$HOME/.emacs.d/bin:$PATH
  '';

  # install packages from nix's official package repository.
  environment.systemPackages = with pkgs; [
    pkgs.unstable.git
    nixd # nix language server
    nixfmt-classic
  ];

  # To make this work, homebrew need to be installed manually, see
  # https://brew.sh The apps installed by homebrew are not managed by nix, and
  # not reproducible!  But on macOS, homebrew has a much larger selection of
  # apps than nixpkgs, especially for GUI apps!

  # work mac comes with brew
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false; # annoying
      # nix-darwin 26.05 passes brew bundle flags (--force-cleanup / --cleanup)
      # that homebrew 7 no longer supports, so no automatic cleanup. check what
      # is not in the Brewfile with `brew bundle cleanup --file=<Brewfile>`
      cleanup = "none";
    };

    taps = [ "CtrlSpice/homebrew-otel-desktop-viewer" ];

    # brew install
    brews = [
      # "otel-desktop-viewer"
    ];

    # brew install --cask
    # these need to be updated manually
    casks = [ "swiftbar" "spotify" "zoom" "intellij-idea" ];

    # mac app store
    # click
    masApps = {
      # removed as they are slow, and apps are still kept
      #amphetamine = 937984704;
      #kindle = 302584613;
      #tailscale = 1475387142;
      #windows-app = 1295203466; # rdp

      # useful for debugging macos key codes
      #key-codes = 414568915;
    };
  };

}
