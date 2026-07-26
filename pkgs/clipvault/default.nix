{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wayland,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clipvault";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "clipvault";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3KXb+IWthxWm6WsI/EiXOatDZ0Z76fMGL96ZNeRrYSQ=";
  };

  cargoHash = "sha256-kRTBUf2GObUqsDB9ewY42I6vQQQPS6wbmeXuj3EVh1g=";

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

  passthru.updateScript = nix-update-script {
    attrPath = "clipvault";
    extraArgs = [ "--flake" ];
  };
})
