{ config, inputs, lib, pkgs, ... }:

let dotfiles = inputs.dotfiles;
in {

  programs.gpg = {
    enable = true;
    package = pkgs.gnupg24;
  };

  # gnu --batch --import
  #  https://github.com/NixOS/nixpkgs/issues/240819#issuecomment-1616760598
  home.file.".gnupg/gpg-agent.conf".text = ''
    # seconds after the last GnuPG activity
    default-cache-ttl 600
    default-cache-ttl-ssh 600

    # max seconds to cache, after extended periods
    max-cache-ttl 1800
    max-cache-ttl-ssh 1800

    # gpg 1password prompt
    pinentry-program "${
      lib.getExe (pkgs.writeShellScriptBin "gpg-1p-pinentry"
        (builtins.readFile (dotfiles + "/gpg-1p-pinentry")))
    }"

    enable-ssh-support

    # prevent scdaemon error messages in syslog regarding a smart card reader
    # you don't have one
    disable-scdaemon
  '';
}
