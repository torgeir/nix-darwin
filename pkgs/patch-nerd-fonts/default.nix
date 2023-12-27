{ lib, stdenvNoCC, fetchFromGitHub, font, pkgs }:
# stdenv no c compiler
stdenvNoCC.mkDerivation rec {
  pname = "${font}-patched-nerd-font";
  version = font.version;

  nativeBuildInputs = [ pkgs.nerd-font-patcher ];

  src = font;

  # https://github.com/hauleth/dotfiles/blob/d2d3e9a1584417792a71f8c876095db1960d154b/modules/iosevka.nix#L48
  buildPhase = ''
    folder=share/fonts/truetype/
    mkdir -p $out
    for f in $(ls ${font}/$folder); do
      # fix same named font files are overwritten, causing only -thin version,
      # i.e. the last one, to be kept
      nerd-font-patcher -o $out/share/fonts/truetype/$f/ -c "$folder/$f";
    done
  '';

  dontInstall = true;
  dontFixup = true;

  meta = with lib; {
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    description = "path font with nerd icons";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
