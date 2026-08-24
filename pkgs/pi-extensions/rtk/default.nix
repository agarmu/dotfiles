{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-rtk";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "MasuRii";
    repo = "pi-rtk-optimizer";
    rev = "v${version}";
    hash = "sha256-Cw0oLzVv674vpC3g5oteCNZSkHpfBN+IdnYDbkai4q4=";
  };

  # Pi supplies the extension's peer dependencies at runtime.
  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "RTK command rewriting and tool output compaction extension for Pi";
    homepage = "https://github.com/MasuRii/pi-rtk-optimizer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
