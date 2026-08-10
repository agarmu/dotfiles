{
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "pi-subagents";
  version = "0.1.0";
  src = ./.;

  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "One-shot isolated subagents for Pi";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
