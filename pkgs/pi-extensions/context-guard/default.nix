{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpmConfigHook,
  pnpm_10,
  fetchPnpmDeps,
}:

stdenv.mkDerivation rec {
  pname = "pi-mono-context-guard";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "emanuelcasco";
    repo = "pi-mono-extensions";
    rev = "b4403dd91e8714099397eceb01eaa3836a48382c";
    hash = "sha256-3d8vIXdtVaJA3PlORxWrQwWGWbWPQU3i+BghjY8ZZ+U=";
  };

  pnpmWorkspaces = [ "extensions/context-guard" ];

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    hash = "sha256-0waT+Kvwk5CB8+LJcps4EdZZn0EZsHLFJu2D3MOHF1A=";
    fetcherVersion = 4;
  };

  nativeBuildInputs = [
    pnpm_10
    pnpmConfigHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r extensions/context-guard/. $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Pi extension that guards context window growth by auto-limiting read and rg output";
    homepage = "https://github.com/emanuelcasco/pi-mono-extensions";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
