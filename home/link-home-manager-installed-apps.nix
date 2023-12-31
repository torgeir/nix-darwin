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
      $DRY_RUN_CMD mv "$tmp_path" "$app_path"
    '';
  };
}
