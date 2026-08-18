{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  moreutils,
}:
buildNpmPackage rec {
  pname = "pi-fancy-footer";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "mavam";
    repo = "pi-fancy-footer";
    rev = "main";
    hash = "sha256-USuDxnMfxycZokX1Nc0joz+3+rse9GgmqhsUJuL5tZQ=";
  };
  npmDepsHash = "sha256-C9k2NJ6g1d+s8NpFdOjXQQ0Uz6Rbuv9Zx5b5p7a9uDU=";
  nativeBuildInputs = [
    jq
    moreutils
  ];
  postPatch = ''
    jq 'walk(if type == "object" then with_entries(select(.key | startswith("@earendil-works/") | not)) else . end)' package.json | sponge package.json
    jq 'walk(if type == "object" then with_entries(select((.key | contains("@earendil-works/")) | not)) else . end)' package-lock.json | sponge package-lock.json
  '';
  dontNpmBuild = true;
  dontNpmPrune = true;
  npmFlags = [
    "--legacy-peer-deps"
    "--ignore-scripts"
  ];
  postInstall = ''cp -r "$out/lib/node_modules/pi-fancy-footer/." "$out/"; rm -rf "$out/lib"'';
  meta = with lib; {
    description = "Compact two-line configurable Pi footer";
    homepage = "https://github.com/mavam/pi-fancy-footer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
