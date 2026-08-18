{
  buildHelixPlugin,
  fetchFromGitHub,
  installRustCdylibHook,
  rustPlatform,
}:
let
  version = "0-unstable-2026-08-02";
  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "helix-file-watcher";
    rev = "ea1ad0dfc1f5f806eed837baf01ef0263cff1be0";
    hash = "sha256-O8qkQX+yYjSCtnZ59jfVJdPYc7XTvMpBw3gXtWtjfAk=";
  };
  native = rustPlatform.buildRustPackage {
    pname = "helix-file-watcher-native";
    inherit version src;
    cargoHash = "sha256-RhxKQSydcY48/aWZGPbJe6pFrKptynMV35BQSD16tXo=";
    cargoBuildFlags = [ "--lib" ];
    nativeBuildInputs = [ installRustCdylibHook ];
    strictDeps = true;
    __structuredAttrs = true;

    meta = {
      description = "Native engine for the Helix file-watcher plugin";
      homepage = "https://github.com/mattwparas/helix-file-watcher";
    };
  };
in
buildHelixPlugin {
  pname = "helix-file-watcher";
  inherit version src native;
  meta = {
    description = "Automatically reload externally modified files in Helix";
    homepage = "https://github.com/mattwparas/helix-file-watcher";
  };
}
