{
  buildHelixPlugin,
  fetchFromGitHub,
  installRustCdylibHook,
  rustPlatform,
}:
let
  version = "0-unstable-2026-08-09";
  src = fetchFromGitHub {
    owner = "mattwparas";
    repo = "helix-file-watcher";
    rev = "8cd0726da47be4a1011c3246ff308c1dfefda9d1";
    hash = "sha256-auqS4wcJGCUJXzRVj4neQLJnqErvty3+3shfq5DU/pg=";
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
