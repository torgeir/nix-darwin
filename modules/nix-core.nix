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
  # turned off due to
  # https://github.com/NixOS/nix/issues/7273#issuecomment-1325073957
  nix.settings.auto-optimise-store = false;
  # nix store optimise (manually instead)

  # linux builder
  # https://nixcademy.com/2024/02/12/macos-linux-builder/
  # root was here previously, @admin is for linux-builder
  nix.settings.trusted-users = [ "root" "@admin" ];
  # sudo launchctl list org.nixos.linux-builder
  # sudo launchctl stop org.nixos.linux-builder
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024; # 40gb
          memorySize = 8 * 1024; # 8gb
        };
        cores = 6;
      };
    };
  };
  # try it
  # nix build --impure  --expr '(with import <nixpkgs> { system = "aarch64-linux"; }; runCommand "foo" { nativeBuildInputs = [ neofetch ]; } "neofetch >> $out" )' && cat result
}
