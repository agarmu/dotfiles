{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libX11,
  nix-update-script,
}:

buildGoModule rec {
  pname = "slk";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "gammons";
    repo = "slk";
    tag = "v${version}";
    hash = "sha256-VZa/oc33obp02a18Wa5T1xF28Rlgfrfqv6XC02/1DjM=";
  };
  subPackages = [ "cmd/slk" ];

  vendorHash = "sha256-jstv3EH3e827KXmbKl7d3GBuLNyrpwEQeRpiM/mYSOY=";

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
