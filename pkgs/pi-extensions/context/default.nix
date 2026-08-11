{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi9-context";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "Chase-C";
    repo = "pi9";
    # No v${version} tag exists upstream; pin the matching commit.
    rev = "52bfc9371d022fbc8243d1701cb436a715b12977";
    hash = "sha256-5K0nZ1++QR6UYBLIVghD7t8HCF+v6fdUreGItJZSPVg=";
  };

  # No runtime dependencies: peer packages are provided by the Pi host.
  installPhase = ''
    runHook preInstall
    cp -r packages/context/. "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Pi extension to show a breakdown of your current context usage";
    homepage = "https://github.com/Chase-C/pi9";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
