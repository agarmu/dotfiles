{
  lib,
  fetchFromGitea,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "omry-server";
  version = "0.20.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "omry";
    repo = "omry";
    rev = "defd99319fe58e81ed0aea92f6bc7d44bd33638b";
    hash = "sha256-HIByMgpLYrPPZfUaevc1plM/zVMAytBD0qMpt9RhxLM=";
  };

  cargoHash = "sha256-cixNEVUR63ngSV7h168EZKb5g6+drV1ycl5vJBuvVAw=";

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
