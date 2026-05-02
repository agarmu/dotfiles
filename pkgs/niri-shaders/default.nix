{
  fetchFromGitHub,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "niri-shaders";
  version = "unstable-2025-03-27";

  src = fetchFromGitHub {
    owner = "jgarza9788";
    repo = "niri-animation-collection";
    rev = "aa26f4e157b818630cb281f6e1968b641c079d69";
    hash = "sha256-DgoudR6etn+t5eYplPcOISPuWMRAulW6ZOCTsyFHi2w=";
  };
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    cp -r animations $out
  '';

  meta = {
    description = "GLSL shaders for Niri from niri-animation-collection";
    homepage = "https://github.com/jgarza9788/niri-animation-collection";
    license = lib.licenses.mit;
  };
}
