{ pkgs, ... }: {

  # enable flakes globally
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;

  # emacs 29 needs older gnupg than 2.4.1 due to hangs, pkgs.gnupg22 seems to
  # work it needs this older libcrypt
  nixpkgs.config.permittedInsecurePackages = [ "libgcrypt-1.8.10" ];

  # clean up every once in a while
  nix.gc.automatic = true;
  # gets rid of duplicate store files
  nix.settings.auto-optimise-store = true;
}
