{ config, lib, pkgs, ... }:

{
  # aerospace does not support binding to fn, this solves that.

  home.packages = [ pkgs.unstable.skhd ];

  home.file.".skhdrc".text = ''
    fn-e : open -a emacs
    fn-i : open -a Firefox\ Developer\ Edition
    fn-c : open -a IntelliJ\ IDEA
    fn-o : open -a Microsoft\ Outlook
    fn-t : open -a Alacritty
    fn-s : open -a Slack
    fn-m : open -a Spotify
    fn-p : open -a 1Password
  '';
}
