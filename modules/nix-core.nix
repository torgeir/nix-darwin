{ pkgs, ... }: {

  # enable flakes globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

  # clean up every once in a while
  nix.gc.automatic = true;
  # gets rid of duplicate store files
  nix.settings.auto-optimise-store = true;
}
