{
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "pi-scratchpad";
  version = "0.1.0";
  src = ./.;

  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Per-session scratchpad plus academic paper search and download tools for Pi agents";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
