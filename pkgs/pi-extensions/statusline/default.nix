{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pi-statusline";
  # No v${version} tag exists upstream; pin the commit that was published as 0.0.2.
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "hsingjui";
    repo = "pi-statusline";
    rev = "894a3d883b87753fa5018dff68f85a2d6a1dfe1c";
    hash = "sha256-P5qCbfygmByah5sVGXijGEo5YF4qStN4gFKA8WPKI3w=";
  };

  # No runtime dependencies: the peer package is provided by the Pi host.
  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Claude Code-compatible command-driven statusline extension for the Pi coding agent";
    homepage = "https://github.com/hsingjui/pi-statusline";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
