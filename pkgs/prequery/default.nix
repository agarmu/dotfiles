{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prequery-preprocess";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "typst-community";
    repo = "prequery-preprocess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6IqwgU2j+siaeqfViE2L86xclWWhtLS8/mQghladPSg=";
  };

  cargoHash = "sha256-ohuhrHPyr/mgEIpBTAm65EcJVxiOYW3uwwn8/ZbpFs8=";

  meta = {
    description = "Preprocessor for prequery metadata embedded in Typst documents";
    homepage = "https://typst-community.github.io/prequery/";
    license = lib.licenses.mit;
    mainProgram = "prequery";
    platforms = lib.platforms.unix;
  };
})
