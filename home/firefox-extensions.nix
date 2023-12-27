{ fetchurl, stdenv, lib, pkgs, ... }:
let
  buildExtension = { pname, version, id, url, sha256, ... }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";
      src = fetchurl { inherit url sha256; };
      preferLocalBuild = true;
      allowSubstitutes = true;
      buildCommand = ''
        # application id of firefox
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${id}.xpi"
      '';
    };
in {

  # curl -s --head https://addons.mozilla.org/firefox/downloads/latest/darkreader/ | grep location | awk '{print $2}' | pbcopy
  # nix-hash --type sha256 --flat <(curl -L -s https://addons.mozilla.org/firefox/downloads/latest/darkreader/)

  darkreader = buildExtension {
    pname = "darkreader";
    version = "4.9.73";
    id = "addon@darkreader.org";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/4205543/darkreader-4.9.73.xpi";
    sha256 = "7c399ff32561886bb80dad0cafaf8f629792b0b71ff1efcf12667e05a2b38f1a";
  };

  ublock-origin = buildExtension {
    pname = "ublock-origin";
    version = "1.54.0";
    id = "uBlock0@raymondhill.net";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/4198829/ublock_origin-1.54.0.xpi";
    sha256 = "9797160908191710ff0858536ba6dc29ecad9923c30b2ad6d3e5e371d759e44d";
  };

  onepassword-x-password-manager = buildExtension {
    pname = "1password-x-password-manager";
    version = "2.15.1";
    id = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/4168788/1password_x_password_manager-2.15.1.xpi";
    sha256 = "2210a7a79456bf59e445e7b751de676a29f610de14c6ea3b04cb2c7763a54b2a";
  };

  vimium-ff = buildExtension {
    pname = "vimium-ff";
    version = "2.0.6";
    id = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/4191523/vimium_ff-2.0.6.xpi";
    sha256 = "94a2d7e88596b65891747d48837deb5440780d57db7ae330d1d7d43d5fe64922";
  };
}
