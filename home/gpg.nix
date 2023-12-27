{ config, lib, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    package = pkgs.gnupg22;
  };

  home.packages = with pkgs; [ pinentry_mac ];

  # gnu --batch --import
  #  https://github.com/NixOS/nixpkgs/issues/240819#issuecomment-1616760598
  home.file.".gnupg/gpg-agent.conf".text = ''
    # seconds after the last GnuPG activity
    default-cache-ttl 28800
    default-cache-ttl-ssh 28800

    # seconds it caches after entering your password
    max-cache-ttl 28800
    max-cache-ttl-ssh 28800

    # allow presetting the passphrase from 1password
    allow-preset-passphrase

    # mac
    pinentry-program "${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";

    enable-ssh-support

    # remember to reload it after editing this file
    #  killall gpg-agent && gpg-connect-agent reloadagent /bye

    # prevent scdaemon error messages in syslog regarding a smart card reader
    # you don't have one
    disable-scdaemon
  '';
}
