{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "beads-viewer";
  version = "0.25.2";

  src = fetchFromGitHub {
    owner = "Dicklesworthstone";
    repo = "beads_viewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xQo26/aKNYjGaLPn1TJGn4nGcLmlnYo+C97JMA1M5nU=";
  };

  vendorHash = null;

  subPackages = [ "cmd/bv" ];

  # CLI tests create isolated Git repositories and configure checkout trust.
  nativeCheckInputs = [ gitMinimal ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "bv --version";
    };
    updateScript = nix-update-script {
      attrPath = "beads-viewer";
      extraArgs = [ "--flake" ];
    };
  };

  meta = {
    description = "Graph-aware terminal UI for the Beads issue tracker";
    homepage = "https://github.com/Dicklesworthstone/beads_viewer";
    changelog = "https://github.com/Dicklesworthstone/beads_viewer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "bv";
    platforms = lib.platforms.unix;
  };
})
