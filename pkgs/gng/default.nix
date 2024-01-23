{ lib, stdenvNoCC, pkgs }:

# stdenv no c compiler
stdenvNoCC.mkDerivation rec {
  pname = "gng";
  version = "v1.0.3";

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = with pkgs.python310Packages; [ python ];

  src = builtins.fetchTarball {
    url = "https://github.com/gdubw/gng/archive/refs/tags/${version}.tar.gz";
    sha256 = "sha256-QbyvCglSuQmSLBSSqVnRFqf9Tv1Bt4bUmfHrfR3Ci4A=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r {bin,lib,gradle} $out
    wrapProgram $out/bin/gw --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with lib; {
    homepage = "https://github.com/gdubw/gng";
    description = "GNG is Not Gradle";
    license = licenses.free;
    platforms = platforms.all;
  };
}

# https://ryantm.github.io/nixpkgs/stdenv/stdenv/

# experiment with it: go to the folder of this file
# > nix repl --expr 'import <nixpkgs> {}'
# :r
# :b import ./default.nix { inherit lib stdenvNoCC fetchFromGitHub pkgs; }

# This derivation produced the following outputs:
#   out -> /nix/store/lwwf45vnbrf2xyg3kvg3nckxjaxxkn9v-gng-v1.0.3
#
# hit c-d
#
# > eza --tree /nix/store/lwwf45vnbrf2xyg3kvg3nckxjaxxkn9v-gng-v1.0.3
# /nix/store/lwwf45vnbrf2xyg3kvg3nckxjaxxkn9v-gng-v1.0.3
# ├── bin
# │  ├── gng
# │  └── gw -> gng
# └── lib
#    └── common.sh
