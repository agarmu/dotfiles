{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpmConfigHook,
  pnpm_10,
  fetchPnpmDeps,
}:

stdenv.mkDerivation rec {
  pname = "pi-sandbox";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "carderne";
    repo = "pi-sandbox";
    rev = "v${version}";
    hash = "sha256-grQv6O1YHQy3uYJ7WZVMCjF1vPaKTdqaMDLQ2qodP7s=";
  };

  pnpmWorkspaces = [ ];

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    hash = "sha256-4jedfkRZSUsNJKNLK7dl82RHbGswS8Rd8c6kb/g8e2E=";
    fetcherVersion = 4;
  };

  nativeBuildInputs = [
    pnpm_10
    pnpmConfigHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r . "$out/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "OS-level sandboxing and permission prompts for Pi tools";
    homepage = "https://github.com/carderne/pi-sandbox";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
