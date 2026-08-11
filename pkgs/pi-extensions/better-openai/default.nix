{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  moreutils,
  imageSupport ? false,
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

  # `/wham/usage` supplies a duration for each quota window, but v0.1.22
  # assumes primary/secondary always mean 5h/7d. Apply the API duration when
  # labelling the footer so a multi-day primary window is not misreported.
  patches = [ ./usage-window-labels.patch ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

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
  ''
  + lib.optionalString (!imageSupport) ''
    # Disable everything related to the openai_image tool.
    sed -i \
      -e '/import { registerOpenAIImage, _imageTest } from ".\/src\/image\.ts";/d' \
      -e '/registerOpenAIImage(pi, config);/d' \
      -e '/imageTest: _imageTest,/d' \
      index.ts
    rm -f src/image.ts tests/image.test.ts
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
