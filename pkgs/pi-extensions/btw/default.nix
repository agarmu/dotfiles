{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "pi-btw";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "narumiruna";
    repo = "pi-extensions";
    rev = "main";
    hash = "sha256-4k1hrUlrxHCjMmowyWraIc8OG/93ZQQ0bcHlUOmsAlg=";
  };
  installPhase = ''
    runHook preInstall
    cp -r packages/pi-btw/. "$out"
    runHook postInstall
  '';
  meta = with lib; {
    description = "Side-question /btw command for Pi";
    homepage = "https://github.com/narumiruna/pi-extensions";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
