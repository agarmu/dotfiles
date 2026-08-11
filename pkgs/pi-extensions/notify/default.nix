{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-notify";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ferologics";
    repo = "pi-notify";
    rev = "v${version}";
    hash = "sha256-8oiWZhV/HpwAZyPL3Upi5EHDcqLwRdJd6SJBJk940tI=";
  };

  # No runtime dependencies: the peer package is provided by the Pi host.
  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Desktop notifications for Pi via OSC 777/99/9 and Windows toast";
    homepage = "https://github.com/ferologics/pi-notify";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
