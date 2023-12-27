{ config, lib, pkgs, ... }: {

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29.overrideAttrs (old: {
      # inspiration https://github.com/noctuid/dotfiles/blob/30f615d0a8aed54cb21c9a55fa9c50e5a6298e80/nix/overlays/emacs.nix
      patches = (old.patches or [ ]) ++ [
        # fix os window role so that yabai can pick up emacs
        (pkgs.fetchpatch {
          url =
            "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
          sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
        })
        (pkgs.fetchpatch {
          url =
            "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
          sha256 = "uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
        })
        # prevent cocoa app refocus after emacs is hidden or quit
        (pkgs.fetchpatch {
          url =
            "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/no-frame-refocus-cocoa.patch";
          sha256 = "QLGplGoRpM4qgrIAJIbVJJsa4xj34axwT3LiWt++j/c=";
        })
      ];
    });
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  xdg.enable = true;
  home = {
    # put doom on path
    sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];
    sessionVariables = {
      # where doom is
      DOOMDIR = "${config.xdg.configHome}/doom.d";
      # where doom writes cache etc
      DOOMLOCALDIR = "${config.xdg.configHome}/doom-local";
      # where doom writes one more file
      DOOMPROFILELOADFILE =
        "${config.xdg.configHome}/doom-local/cache/profile-load.el";
    };
  };
  xdg.configFile = {
    # git clone git@github.com:torgeir/.emacs.d.git ~/.doom.d
    "doom.d".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.doom.d";
    "emacs" = {
      source = builtins.fetchGit {
        url = "https://github.com/hlissner/doom-emacs";
        rev = "03d692f129633e3bf0bd100d91b3ebf3f77db6d1";
      };
      # rev bumps will make doom sync run
      onChange = "${pkgs.writeShellScript "doom-change" ''
        # where your .doom.d files go
        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"

        # where doom will write to
        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"

        # https://github.com/doomemacs/doomemacs/issues/6794
        export DOOMPROFILELOADFILE="${config.home.sessionVariables.DOOMPROFILELOADFILE}"

        # cannot find git, cannot find emacs
        export PATH="$PATH:/run/current-system/sw/bin"
        export PATH="$PATH:/etc/profiles/per-user/torgeir/bin"

        if command -v emacs; then
          # not already installed
          if [ ! -d "$DOOMLOCALDIR" ]; then
            # having the env generated also prevents doom install from asking y/n on stdin,
            # also bring ssh socket
            ${config.xdg.configHome}/emacs/bin/doom env -a ^SSH_ -a ^GPG
            echo "doom-change :: Doom not installed: run doom install. ::"
          else
            echo "doom-change :: Doom already present: upgrade packages with doom sync -u ::"
            ${config.xdg.configHome}/emacs/bin/doom sync
          fi
        else
          echo "doom-change :: No emacs on path. ::"
        fi

      ''}";
    };
  };
}
