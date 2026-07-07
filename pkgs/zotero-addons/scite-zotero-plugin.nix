{
  lib,
  buildNpmPackage,
  cacert,
  cairo,
  fetchFromGitHub,
  giflib,
  libjpeg,
  libpng,
  nodejs_22,
  pango,
  pkg-config,
  python3,
  python3Packages,
}:

buildNpmPackage rec {
  pname = "scite-zotero-plugin";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "scitedotai";
    repo = "scite-zotero-plugin";
    tag = "v${version}";
    hash = "sha256-T/isSjNQtCEh3/8E7hnxCoc9kVIxfQqDfeZBdzz8T9c=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-boTVVahb87Kuc4UOFPLoqoUCYfNTgNFe8X9MIcBj7Jc=";

  buildPhase =
    # npm would run prebuild (lint) automatically, so we override to skip it
    ''
      runHook preBuild
      export PATH=$PWD/node_modules/.bin:$PATH
      tsc --noEmit
      node esbuild.js
      zotero-plugin-zipup build scite-zotero-plugin
      runHook postBuild
    '';

  nativeBuildInputs = [
    cacert
    pkg-config
    python3
    python3Packages.setuptools
  ];

  buildInputs = [
    cairo
    giflib
    libjpeg
    libpng
    pango
  ];

  NODE_OPTIONS = "--use-openssl-ca";

  installPhase = ''
    runHook preInstall
    install -m444 -D xpi/*.xpi $out/share/zotero/addons/scite-zotero-plugin.xpi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Scite Zotero plugin — Smart Citation tallies in Zotero";
    homepage = "https://github.com/scitedotai/scite-zotero-plugin";
    license = licenses.unfreeRedistributable;
    platforms = platforms.all;
  };
}
