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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "clipvault";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RpY2j39llW6oirkYXxNp4343n3erYupRKXpQYq4TVWM=";
  };

  cargoHash = "sha256-U+/djxC0QpQMq5MFqdORMn6SaXqkTre9iQ0WNxubo2Y=";

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
