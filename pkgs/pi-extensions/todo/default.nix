{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi9-todo";
  version = "0.3.7";

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
    cp -r packages/todo/. "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Phased, session-aware todo planning for Pi agents";
    homepage = "https://github.com/Chase-C/pi9/tree/main/packages/todo#readme";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
