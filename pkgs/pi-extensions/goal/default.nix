{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "pi-goal";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "narumiruna";
    repo = "pi-extensions";
    rev = "main";
    hash = "sha256-4k1hrUlrxHCjMmowyWraIc8OG/93ZQQ0bcHlUOmsAlg=";
  };
  installPhase = ''
    runHook preInstall
    cp -r packages/pi-goal/. "$out"
    runHook postInstall
  '';
  meta = with lib; {
    description = "Codex-like verified /goal workflow for Pi";
    homepage = "https://github.com/narumiruna/pi-extensions";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
