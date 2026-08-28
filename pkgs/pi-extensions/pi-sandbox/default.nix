{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pnpmConfigHook,
  pnpm_10,
  fetchPnpmDeps,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-sandbox";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "carderne";
    repo = "pi-sandbox";
    rev = "v${version}";
    hash = "sha256-Yax4DgdNeUYhUaAUvsriw8oKmYzlzY8rus7s5gIypGU=";
  };

  patches = [ ./patches/allow-pi-clipboard-images.patch ];

  pnpmWorkspaces = [ ];

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_10;
    hash = "sha256-ayokpzo89jC6GtKPvBaHnAeyovaU4GZ6pN+W+uf4zjs=";
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
