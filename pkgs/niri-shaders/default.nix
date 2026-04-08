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
    rev = "0b77e739f0007f7fffedd014e44e68daccddbd3b";
    hash = "sha256-unwQ5RyaL+6019qgTqVqE2eDVsq9EUvgmhRHgPqnQww=";
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
