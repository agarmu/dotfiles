{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-goal";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "Michaelliv";
    repo = "pi-goal";
    tag = "v${version}";
    hash = "sha256-bp/Gk/iPN0Cx7hIbAKkIOuRgb0gzCeL8bgjVU8iXBto=";
  };

  installPhase = ''
    runHook preInstall
    cp -r ./. "$out"
    substituteInPlace "$out/package.json" \
      --replace-fail '".pi/extensions/pi-goal"' '".pi/extensions/pi-goal/index.ts"'
    runHook postInstall
  '';

  meta = with lib; {
    description = "Codex-like verified /goal workflow for Pi";
    homepage = "https://github.com/Michaelliv/pi-goal";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
