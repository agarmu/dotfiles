{
  lib,
  fetchFromGitea,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "omry-cli";
  version = "0.15.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "omry";
    repo = "omry-cli";
    tag = "0.15.3";
    hash = "sha256-s7dF2Wtx4su8CxiRaDhYkGepqiPDjCTemBG2y0S9xRo=";
  };

  cargoHash = "sha256-JHjxqp2lbLUc3TsrJQlU0MBE/73Gh8tfjQT2Bq3UGfI=";

  # Upstream snapshot tests are stale for the tagged release.
  doCheck = false;

  meta = {
    description = "Experimental terminal client for Omry";
    homepage = "https://codeberg.org/omry/omry-cli";
    license = lib.licenses.gpl3Only;
    mainProgram = "omry-cli";
    platforms = lib.platforms.unix;
  };
}
