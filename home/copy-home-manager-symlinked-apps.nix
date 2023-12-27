{ config, lib, pkgs, ... }:

{

  # unused
  # https://gist.github.com/voanhduy1512/e7ca398b73f00de3fac41931dad812d4
  #
  # temporary hack from
  # https://github.com/nix-community/home-manager/issues/1341#issuecomment-778820334
  # Even though nix-darwin support symlink to ~/Application or ~/Application/Nix Apps
  # Spotlight doesn't like symlink as all or it won't index them
  home.activation = {
    copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
    in lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      dir="$HOME/Applications/Home Manager Apps"
      if [ -d "$dir" ]; then
        rm -rf "$dir"
      fi
      mkdir -p "$dir"
      for app in ${apps}/Applications/*; do
        target="$dir/$(basename "$app")"
        $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$app" "$dir"
        $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
      done
    '';
  };
}
