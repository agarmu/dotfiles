{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  moreutils,
}:

buildNpmPackage rec {
  pname = "pi-web-search";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "lexiupon";
    repo = "pi-web-search";
    rev = "v${version}";
    hash = "sha256-jk3StE7i0rj9aaxcaYiU8LteHW1/xc7KFsjwbsUKWnQ=";
  };
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-yGr/KJRJNQqH1FqmgqIy5HhG2niE9J7WW1zrWxVfp84=";

  makeCacheWriteable = true;
  dontNpmBuild = true;
  dontNpmPrune = true;

  npmInstallFlags = [ "--legacy-peer-deps" ];
  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [
    jq
    moreutils
  ];

  # The lockfile auto-installs the pi-ai/pi-coding-agent/pi-tui peers via
  # shrinkwrap entries that lack integrity, which breaks prefetch-npm-deps.
  # Those packages are provided by the Pi host, so strip them entirely.
  postPatch = ''
    ${jq}/bin/jq 'del(.peerDependencies)' package.json | ${moreutils}/bin/sponge package.json
    ${jq}/bin/jq 'del(.packages[""].peerDependencies) | .packages |= with_entries(select(.key | contains("@earendil-works") | not))' package-lock.json | ${moreutils}/bin/sponge package-lock.json
  '';

  postInstall = ''
    cp -r "$out/lib/node_modules/@alexion42/pi-web-search/." "$out/"
    rm -rf "$out/lib"
  '';

  meta = with lib; {
    description = "Exa-powered web search and URL reading for Pi with readability, markdown conversion, and PDF extraction";
    homepage = "https://github.com/lexiupon/pi-web-search";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
