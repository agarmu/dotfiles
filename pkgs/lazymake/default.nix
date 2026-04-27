{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lazymake";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "rshelekhov";
    repo = "lazymake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8H12nfGI2ZMuPIwOCPEUJtW7xuTa/NYkktttpmOAm0U=";
  };

  vendorHash = "sha256-X/n7eoughxIP42JcLfifnbyqjYzRQBGsQvvCvFElotY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Modern TUI for Makefiles with interactive target selection, dependency visualization, and command safety analysis";
    homepage = "https://github.com/rshelekhov/lazymake";
    changelog = "https://github.com/rshelekhov/lazymake/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "lazymake";
  };
})
