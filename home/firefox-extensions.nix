{ fetchurl, stdenv, lib, pkgs, ... }:

let
  # Copyright (C) 2019-2022 Robert Helgesson
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

  # find urls and sha256 by
  # curl -s --head https://addons.mozilla.org/firefox/downloads/latest/darkreader/ | grep location | awk '{print $2}' | pbcopy
  # nix-hash --type sha256 --flat <(curl -L -s https://addons.mozilla.org/firefox/downloads/latest/darkreader/)
  #
  # find ids by installing a plugin manually then going to about:debugging#/runtime/this-firefox
  # remove it then add it here

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

  multi-account-containers = buildExtension {
    pname = "multi-account-containers";
    version = "8.1.3";
    id = "@testpilot-containers";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/4186050/multi_account_containers-8.1.3.xpi";
    sha256 = "33edd98d0fc7d47fa310f214f897ce4dfe268b0f868c9d7f32b4ca50573df85c";
  };

  firefox-color = buildExtension {
    pname = "firefox-color";
    version = "2.1.7";
    id = "FirefoxColor@mozilla.com";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/3643624/firefox_color-2.1.7.xpi";
    sha256 = "b7fb07b6788f7233dd6223e780e189b4c7b956c25c40493c28d7020493249292";
  };

  tree-style-tab = buildExtension {
    pname = "tree-style-tab";
    version = "3.9.19";
    id = "treestyletab@piro.sakura.ne.jp";
    url =
      "https://addons.mozilla.org/firefox/downloads/file/4197314/tree_style_tab-3.9.19.xpi";
    sha256 = "bb67f47a554f8f937f4176bee6144945eb0f240630b93f73d2cff49f0985b55a";
  };

}
