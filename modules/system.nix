{ pkgs, ... }: {

  # https://daiderd.com/nix-darwin/manual/index.html#sec-options

  time.timeZone = "Europe/Oslo";

  system = {

    # activationScripts are executed every time you boot the system
    # or run `nixos-rebuild` / `darwin-rebuild`.

    activationScripts.postUserActivation.text = ''
      echo "Reduce Menu Bar padding"
      defaults write -globalDomain NSStatusItemSelectionPadding -int 6
      defaults write -globalDomain NSStatusItemSpacing -int 6
      # revert it
      #defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
      #defaults -currentHost delete -globalDomain NSStatusItemSpacing

      # activateSettings -u will reload the settings from the database and apply
      # them to the current session, so we do not need to logout and login again
      # to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

    defaults = {
      # clock
      menuExtraClock.Show24Hour = true;
      menuExtraClock.ShowSeconds = true;

      # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/trackpad.nix
      trackpad = {
        # tap to click
        Clicking = true;
        # tap-tap-drag to drag
        Dragging = true;
        # two-finger-tap right click
        TrackpadRightClick = true;
      };

      # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/NSGlobalDomain.nix
      NSGlobalDomain = {
        # keyboard navigation in dialogs
        AppleKeyboardUIMode = 3;

        # disable press-and-hold for keys in favor of key repeat
        ApplePressAndHoldEnabled = false;

        # fast key repeat rate when hold
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
      };

      # killall Dock to make them have effect
      # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/dock.nix
      dock = {
        autohide = true;
        magnification = true;
        # most recently used spaces
        mru-spaces = false;
        tilesize = 32;
        largesize = 96;
      };

      # https://github.com/LnL7/nix-darwin/blob/master/modules/system/defaults/finder.nix
      finder = {
        # bottom status bar
        ShowStatusBar = true;
        ShowPathbar = true;

        # default to list view
        FXPreferredViewStyle = "Nlsv";
        # full path in window title
        _FXShowPosixPathInTitle = true;
      };
    };

    # error from nix-darwin without this one
    stateVersion = 5;
  };

  # touchid for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # create /etc/zshrc that loads the nix-darwin environment,
  # required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;

  # load env vars set via home manager
  environment.extraInit = let
    homeManagerSessionVars =
      "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
  in ''
    [[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}
  '';
}
