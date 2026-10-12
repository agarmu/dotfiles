{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libX11,
  nix-update-script,
  stdenv,
}:

buildGoModule rec {
  pname = "slk";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "gammons";
    repo = "slk";
    tag = "v${version}";
    hash = "sha256-wp4c37c4BMKJzszI1pl751+ATe21Azr4gNN4g7xgkx8=";
  };
  subPackages = [ "cmd/slk" ];

  vendorHash = "sha256-/J4gr4m9v6Y0Be8BU4wepIdl2sjoPh0pFCvJL2kIeLk=";

  buildInputs = lib.optional stdenv.hostPlatform.isLinux libX11;

  # The test suite starts HTTP servers on loopback.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A blazingly fast Slack TUI";
    homepage = "https://github.com/gammons/slk";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "slk";
    platforms = platforms.unix;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "slk";
    extraArgs = [ "--flake" ];
  };
}
