{ config, lib, pkgs, ... }:
let alacritty = pkgs.alacritty;
in {

  programs.alacritty = {
    enable = true;
    package = alacritty.overrideAttrs (attrs: rec {
      pname = "alacritty-head";
      version = "0.13.1";
      name = "${pname}-${version}";
      src = pkgs.fetchFromGitHub {
        owner = "alacritty";
        repo = "alacritty";
        rev = "refs/tags/v${version}";
        sha256 = "sha256-Nn/G7SkRuHXRSRgNjlmdX1G07sp7FPx8UyAn63Nivfg=";
      };
      # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393
      nativeBuildInputs = alacritty.nativeBuildInputs ++ [ pkgs.scdoc ];
      cargoDeps = alacritty.cargoDeps.overrideAttrs (lib.const {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-7JaM47MYfVSmTqc+D86jcJEpWE0BNmgLhZ9x6tTSH64=";
      });
      postInstall = ''
        mkdir $out/Applications
        cp -r extra/osx/Alacritty.app $out/Applications
        ln -s $out/bin $out/Applications/Alacritty.app/Contents/MacOS
        installShellCompletion --zsh extra/completions/_alacritty
        installShellCompletion --bash extra/completions/alacritty.bash
        installShellCompletion --fish extra/completions/alacritty.fish

        install -dm 755 "$out/share/man/man1"
        install -dm 755 "$out/share/man/man5"
        scdoc < extra/man/alacritty.1.scd | gzip -c > "$out/share/man/man1/alacritty.1.gz"
        scdoc < extra/man/alacritty-msg.1.scd | gzip -c > "$out/share/man/man1/alacritty-msg.1.gz"
        scdoc < extra/man/alacritty.5.scd | gzip -c > "$out/share/man/man5/alacritty.5.gz"
        scdoc < extra/man/alacritty-bindings.5.scd | gzip -c > "$out/share/man/man5/alacritty-bindings.5.gz"

        # install -Dm 644 alacritty.yml $out/share/doc/alacritty.yml

        install -dm 755 "$terminfo/share/terminfo/a/"
        tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
        mkdir -p $out/nix-support
        echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
      '';
    });
  };
}
