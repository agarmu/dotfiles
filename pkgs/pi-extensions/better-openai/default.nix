{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  moreutils,
}:

buildNpmPackage rec {
  pname = "pi-better-openai";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "mattleong";
    repo = "pi-better-openai";
    rev = "v${version}";
    hash = "sha256-ZdEOGWbmxoT/RYJQaA1hxa7WErADjDgp6yej6JesYFw=";
  };

  npmDepsHash = "sha256-104Fet+8lFxsqd+OIVshhLRDTTQwdZv3AbPA6SlIllM=";

  dontNpmBuild = true;
  dontNpmPrune = true;

  npmInstallFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [
    jq
    moreutils
  ];

  # The lockfile bundles the pi-coding-agent dev toolchain via shrinkwrap
  # entries that lack integrity, which breaks prefetch-npm-deps. Strip the
  # dev tree; only sharp is a runtime dependency.
  postPatch = ''
    ${jq}/bin/jq '.devDependencies = {}' package.json | ${moreutils}/bin/sponge package.json
    ${jq}/bin/jq 'del(.packages[""].devDependencies) | .packages |= with_entries(select(.value.dev | not))' package-lock.json | ${moreutils}/bin/sponge package-lock.json
  '';

  postInstall = ''
    cp -r "$out/lib/node_modules/pi-better-openai/." "$out/"
    rm -rf "$out/lib"
  '';

  meta = with lib; {
    description = "Personal pi extension that improves OpenAI with fast mode, usage stats, and footer polish";
    homepage = "https://github.com/mattleong/pi-better-openai";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
