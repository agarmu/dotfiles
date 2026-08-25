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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "gammons";
    repo = "slk";
    tag = "v${version}";
    hash = "sha256-gYRG4/Kir4Pn2OLg25Fm834sIJ0KNPoGgf1Rdim1ox8=";
  };
  subPackages = [ "cmd/slk" ];

  vendorHash = "sha256-deqCUDgRvhe/Bpmy+9bIHjSBo+KTCtAN2XcGMhAj/G0=";

  buildInputs = lib.optional stdenv.hostPlatform.isLinux libX11;

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
