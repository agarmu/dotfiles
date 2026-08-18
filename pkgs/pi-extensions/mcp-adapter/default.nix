{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  moreutils,
}:
buildNpmPackage rec {
  pname = "pi-mcp-adapter";
  version = "2.26.0";
  src = fetchFromGitHub {
    owner = "nicobailon";
    repo = "pi-mcp-adapter";
    rev = "main";
    hash = "sha256-meIyWlYVDVFZkbUiZA2aP5SUq34/JZxIeGHTV2/9tdg=";
  };
  npmDepsHash = "sha256-VqfIQWaevXgYUa0pz/fFaXKgIcBD3BknFocVy/N0p4A=";
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postPatch = ''
    ${jq}/bin/jq 'walk(if type == "object" then with_entries(select(.key | startswith("@earendil-works/") | not)) else . end)' package.json | ${moreutils}/bin/sponge package.json
    ${jq}/bin/jq 'walk(if type == "object" then with_entries(select((.key | contains("@earendil-works/")) | not)) else . end)' package-lock.json | ${moreutils}/bin/sponge package-lock.json
  '';
  dontNpmBuild = true;
  dontNpmPrune = true;
  npmFlags = [
    "--legacy-peer-deps"
    "--ignore-scripts"
  ];
  postInstall = ''cp -r "$out/lib/node_modules/pi-mcp-adapter/." "$out/"; rm -rf "$out/lib"'';
  meta = with lib; {
    description = "Token-efficient MCP adapter for Pi";
    homepage = "https://github.com/nicobailon/pi-mcp-adapter";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
