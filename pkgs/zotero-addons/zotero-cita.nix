{
  lib,
  buildNpmPackage,
  cacert,
  fetchFromGitHub,
  fetchgit,
  nodejs_22,
  python3,
  python3Packages,
}:

buildNpmPackage rec {
  pname = "zotero-cita";
  version = "1.0.0-beta.19";

  src = fetchFromGitHub {
    owner = "zotero-cita";
    repo = "zotero-cita";
    tag = "v${version}";
    hash = "sha256-PxA5Y0qoiZ3yu2gLd0S0Z+ng5RFjQQccaKQJFEwZyF4=";
  };

  localCitationNetwork = fetchgit {
    url = "https://github.com/zotero-cita/Local-Citation-Network.git";
    rev = "b234cf6f73d4a4c1bcf3f7dd8c8969a3744d4922";
    hash = "sha256-869bSUaTVyVwXziQSnRdwajp4vdBWgXzkBua7vMeEK4=";
  };

  postPatch = ''
    cp -r ${localCitationNetwork}/* Local-Citation-Network/
    chmod -R u+w Local-Citation-Network/
  '';

  nodejs = nodejs_22;

  npmDepsHash = "sha256-2o7kiBN6e1WyKbK+Y1POkL03V+xaTupdrVYgtFqU7Ik=";

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
    install -m444 -D build/*.xpi $out/share/zotero/addons/zotero-cita.xpi
    runHook postInstall
  '';

  passthru.extensionId = "zotero-wikicite@wikidata.org";

  meta = with lib; {
    description = "Cita: a Wikidata addon for Zotero with citations metadata support";
    homepage = "https://github.com/zotero-cita/zotero-cita";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
