{
  buildHelixPlugin,
  fetchFromGitHub,
  installRustCdylibHook,
  lib,
  rustPlatform,
}:
let
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter.hx";
    tag = "v${version}";
    hash = "sha256-pxvD4yJ1qtS4lUpJIIJZdYnDEYY415aZ03ufBoIt6hQ=";
  };
  native = rustPlatform.buildRustPackage {
    pname = "scooter-hx-native";
    inherit version src;
    cargoHash = "sha256-QQ9ISkhRUsp/FNiMHSzZTfWmpnU7AD84bdo3GkIbjOo=";
    cargoBuildFlags = [ "--lib" ];
    nativeBuildInputs = [ installRustCdylibHook ];
    strictDeps = true;
    __structuredAttrs = true;

    meta = {
      description = "Native engine for the Scooter Helix plugin";
      homepage = "https://github.com/thomasschafer/scooter.hx";
      license = lib.licenses.mit;
    };
  };
in
buildHelixPlugin {
  pname = "scooter.hx";
  inherit version src native;
  meta = {
    description = "Interactive find-and-replace Helix plugin";
    homepage = "https://github.com/thomasschafer/scooter.hx";
    license = lib.licenses.mit;
  };
}
