{
  stdenvNoCC,
  texlive,
}:

stdenvNoCC.mkDerivation {
  pname = "kpfonts-otf";
  inherit (texlive.pkgs.kpfonts-otf) version;

  src = texlive.pkgs.kpfonts-otf.tex;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    find "$src" -type f -name '*.otf' \
      -exec install -Dm644 {} "$out/share/fonts/opentype/" \;

    runHook postInstall
  '';
}
