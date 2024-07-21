{ config, lib, pkgs, ... }: {

  # TODO is this better
  # https://github.com/okpedersen/dotfiles/blob/98c7fb9eb57546ca58df8257b4bd862d2281d071/darwin-application-activation.nix
  # Based on this comment
  # https://github.com/nix-community/home-manager/issues/1341#issuecomment-1466965161
  disabledModules = [ "targets/darwin/linkapps.nix" ];

  home.activation = {
    copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      echo "Linking Home Manager applications..." 2>&1
      app_path="$HOME/Applications/Home Manager Apps"
      tmp_path="$(mktemp -dt "home-manager-applications.XXXXXXXXXX")" || exit 1
      ${pkgs.fd}/bin/fd \
        -t l -d 1 . ${apps}/Applications \
      	-x $DRY_RUN_CMD ${pkgs.mkAlias} -L {} "$tmp_path/{/}"
      $DRY_RUN_CMD rm -rf "$app_path"

      $DRY_RUN_CMD mkdir -p "$app_path"
      # $DRY_RUN_CMD mv "$tmp_path" "$app_path"
      $DRY_RUN_CMD mv $tmp_path/*.app "$HOME/Applications"

      # copy some apps to /Applications
      for file in \
          "$HOME/Applications/Alacritty.app" \
          "$HOME/Applications/Firefox Developer Edition.app" \
        ; do
        existing="/Applications/$(basename "$file")"
        [[ -d "$existing" ]] && echo App already installed, refusing to copy it to /Applications: $existing && continue
        # lookup the alias path of what home manager installed
        aliased=$(/usr/bin/osascript -e "tell application \"Finder\" to get the POSIX path of (original item of alias POSIX file \"$file\" as alias)")
        # remove trailing slash
        actual="''${aliased%/}"
        # copy it into /Applications
        cp -fHRL "$actual" "/Applications/" || true
        chown -R torgeir:admin "/Applications/$(basename "$actual")" || true
      done
    '';
  };
}
