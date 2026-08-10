{
  gnutar,
  lib,
  poppler-utils,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "pi-scratchpad";
  version = "0.2.0";
  src = ./.;

  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    substituteInPlace "$out/src/papers/corpus.ts" \
      --replace-fail '@PDFTOTEXT@' '${poppler-utils}/bin/pdftotext' \
      --replace-fail '@TAR@' '${gnutar}/bin/tar'
    runHook postInstall
  '';

  meta = with lib; {
    description = "Per-session scratchpad plus academic paper search and download tools for Pi agents";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
