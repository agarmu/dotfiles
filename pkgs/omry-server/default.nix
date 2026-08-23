{
  lib,
  fetchFromGitea,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "omry-server";
  version = "0-unstable-2026-08-19";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "omry";
    repo = "omry";
    rev = "6fbd10b441dee9b4a38abf2e53a6f090d1d45917";
    hash = "sha256-s6tR3UYa7vOXXioKBsDMFtbp643NCUQ/2TTTgNFT0j4=";
  };

  cargoHash = "sha256-PQSRcP3ogX4BFxPtH7QsKsw9+IULydaqHtxaUkEEOk0=";

  cargoBuildFlags = [
    "--package"
    "omry-server"
  ];
  cargoInstallFlags = [
    "--package"
    "omry-server"
  ];

  # Integration tests require a Docker daemon and Typesense.
  doCheck = false;

  meta = {
    description = "A searchable, offline archive of web pages";
    homepage = "https://codeberg.org/omry/omry";
    license = lib.licenses.agpl3Only;
    mainProgram = "omry-server";
    platforms = lib.platforms.unix;
  };
}
