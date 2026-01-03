{ config, inputs, pkgs, lib, ... }:

let dotfiles = inputs.dotfiles;
in {

  # moar https://github.com/yuanw/nix-home/blob/main/modules/macintosh.nix

  # import sub modules
  imports = [
    ./link-home-manager-installed-apps.nix
    ./docker.nix
    ./gw.nix
    ./gpg.nix
    ./fonts.nix
    (inputs.nix-home-manager + "/modules/alacritty.nix")
    (inputs.nix-home-manager + "/modules/nvim.nix")
    # TODO
    # (inputs.nix-home-manager + "/modules/git.nix")
    (inputs.nix-home-manager + "/modules/firefox.nix")
    (inputs.nix-home-manager + "/modules/zoxide.nix")
    (inputs.nix-home-manager + "/modules/shell-tooling.nix")
    (inputs.nix-home-manager + "/modules/tmux.nix")
    (inputs.nix-home-manager.homeManagerModules.emacs)
  ];

  programs.t-firefox = {
    enable = true;
    package = pkgs.firefox-devedition-bin;
    extraEngines = (import ./firefox-da.nix { });
  };
  programs.t-doomemacs.enable = true;
  programs.t-nvim.enable = true;
  programs.t-terminal.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
  };
  programs.t-tmux.enable = true;
  programs.t-zoxide.enable = true;
  programs.t-shell-tooling.enable = true;
  programs.t-git = {
    enable = true;
    # gh version >2.40.0
    # https://github.com/cli/cli/issues/326
    ghPackage = pkgs.unstable.gh;
  };

  # home manager needs this
  home = {
    username = "torgeir";
    homeDirectory = "/Users/torgeir";
    stateVersion = "23.11";
  };

  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/
  home.packages = with pkgs; [
    coreutils

    openconnect

    # gemma etc needs newer ollama
    pkgs.unstable.ollama

    pkgs.unstable.nerd-fonts.iosevka
    pkgs.unstable.nerd-fonts.iosevka-term

    pkgs.unstable.aerospace
    pkgs.unstable.jankyborders

    pkgs.qmk
  ];

  # TODO hardware.keyboard.zsa.enable

  home.file = {
    ".config/dotfiles".source = dotfiles;
    ".config/dotfiles".onChange = ''
      echo "Fixing swiftbar path"
      /usr/bin/defaults write com.ameba.Swiftbar PluginDirectory \
        $(/etc/profiles/per-user/torgeir/bin/readlink ~/.config/dotfiles)/swiftbar/scripts
      echo swiftbar plugin directory is $(/usr/bin/defaults read com.ameba.Swiftbar PluginDirectory)
      /usr/bin/killall SwiftBar > /dev/null 2> /dev/null
      /usr/bin/open /Applications/SwiftBar.app
    '';

    "Library/KeyBindings/DefaultKeyBinding.dict".source = dotfiles
      + "/DefaultKeyBinding.dict";

    ".ideavimrc".source = dotfiles + "/ideavimrc";

    ".aerospace.toml".source = dotfiles + "/aerospace.toml";
    ".aerospace.toml".onChange =
      "/etc/profiles/per-user/torgeir/bin/aerospace reload-config";
  };
}
