{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpmConfigHook,
  pnpm_10,
  fetchPnpmDeps,
}:

stdenv.mkDerivation rec {
  pname = "pi-guardrails";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "aliou";
    repo = "pi-guardrails";
    rev = "v${version}";
    hash = "sha256-3t0zudRxifBNDidxxyPdM+eLQ/DPgNbpo9qFVo2hOdk=";
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
    hash = "sha256-YiNmu30PuusUVV36swVuwVOEXwa+GzK46/MmjrYiMrs=";
    fetcherVersion = 4;
  };

  nativeBuildInputs = [
    pnpm_10
    pnpmConfigHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r . $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Security hooks for Pi: file protection policies, path access control, and permission gates";
    homepage = "https://github.com/aliou/pi-guardrails";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
