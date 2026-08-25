{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  moreutils,
}:
buildNpmPackage rec {
  pname = "pi-fancy-footer";
  version = "3.0.1";
  src = fetchFromGitHub {
    owner = "mavam";
    repo = "pi-fancy-footer";
    rev = "v${version}";
    hash = "sha256-9qZFRiSTwZnK+PFLRQGjGZnv1zdGg+Vq0jXVqqIybMI=";
  };
  npmDepsHash = "sha256-476zWw8+vQwUZ0/s3nOPbn70JUOT8kcQKPC+2sQwFoI=";
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
  postInstall = ''cp -r "$out/lib/node_modules/pi-fancy-footer/." "$out/"; rm -rf "$out/lib"'';
  meta = with lib; {
    description = "Compact two-line configurable Pi footer";
    homepage = "https://github.com/mavam/pi-fancy-footer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
