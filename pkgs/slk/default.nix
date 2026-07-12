{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libX11,
  nix-update-script,
}:

buildGoModule rec {
  pname = "slk";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "gammons";
    repo = "slk";
    tag = "v${version}";
    hash = "sha256-Mns5HBBz5iql/AhlZxFEK/VcPn3TPID+RgPwsGwOgvs=";
  };
  subPackages = [ "cmd/slk" ];

  vendorHash = "sha256-dPa469oNv6eYyDdly3uhc273DAGz+erc0E3K/am7WoY=";

  buildInputs = [ libX11 ];

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
