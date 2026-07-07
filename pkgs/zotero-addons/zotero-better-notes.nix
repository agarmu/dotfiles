{
  lib,
  buildNpmPackage,
  cacert,
  fetchFromGitHub,
  nodejs_22,
  python3,
  python3Packages,
}:

buildNpmPackage rec {
  pname = "zotero-better-notes";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "windingwind";
    repo = "zotero-better-notes";
    tag = "v${version}";
    hash = "sha256-2aMbpF4c6IyADKdYF5q7HY6/P+drbc22P7Nhd+pVX34=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-HdCBPS8n5EymiRU4Ho9QosTbXI2ppTRhJ/17jIlKgxA=";

  forceGitDeps = true;

  makeCacheWritable = true;

  npmBuildScript = "build";

  nativeBuildInputs = [
    python3
    python3Packages.setuptools
    cacert
  ];

  NODE_OPTIONS = "--use-openssl-ca";

  npmInstallFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    runHook preInstall
    install -m444 -D build/*.xpi $out/share/zotero/addons/zotero-better-notes.xpi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Everything about note management. All in Zotero.";
    homepage = "https://github.com/windingwind/zotero-better-notes";
    license = licenses.agpl3Only;
    platforms = platforms.all;
  };
}
