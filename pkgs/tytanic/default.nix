{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tytanic";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "typst-community";
    repo = "tytanic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NtJrsrMwMyKQBbwjq03OaIrhfqbM+qO9C5jVCAWGmCQ=";
  };

  cargoHash = "sha256-gqIsrQLwOcs+FTVhu8lgQfISiGQVVCnmMHJTCgD9fh0=";

  cargoBuildFlags = [ "--package=tytanic" ];
  cargoInstallFlags = [ "--package=tytanic" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "Test runner for Typst projects";
    homepage = "https://typst-community.github.io/tytanic/";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "tt";
    platforms = lib.platforms.unix;
  };
})
