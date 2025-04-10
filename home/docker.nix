{ pkgs, ... }: {

  home.packages = with pkgs; [

    # nix 23.11 is colima 0.5.6
    # https://github.com/abiosoft/colima/issues/913
    # try unstable which is colima 0.8.1
    pkgs.unstable.colima
    # colima start --edit to tune its resources
    # colima start --vz-rosetta for emulating x86 (sql server need this)

    docker
    docker-compose
    docker-credential-helpers
  ];

}
