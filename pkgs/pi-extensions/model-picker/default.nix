{
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "pi-model-picker";
  version = "0.1.0";
  src = ./.;

  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Categorized keyboard-driven model selector for Pi";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
