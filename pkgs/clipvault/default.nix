{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wayland,
}:
rustPlatform.buildRustPackage {
  pname = "clipvault";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "clipvault";
    rev = "v1.1.1";
    hash = "sha256-iETuHXMUllQstKcNc7p02gU230kPfmEFXYqBh2+HMy4=";
  };

  cargoHash = "sha256-hmr3N/K+cj87OQDoCz2G4vWoNByRfh78rd0BtGJN1hA=";

  doCheck = false; # tests require filesystem access (SQLite), fails in sandbox

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ wayland ];

  meta = {
    description = "Clipboard manager for Wayland with time-based history pruning";
    homepage = "https://github.com/Rolv-Apneseth/clipvault";
    license = lib.licenses.agpl3Only;
    mainProgram = "clipvault";
    platforms = lib.platforms.linux;
  };
}
