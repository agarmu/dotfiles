{
  lib,
  buildNpmPackage,
  cacert,
  fetchFromGitHub,
  fetchgit,
  nodejs_22,
  python3,
  python3Packages,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "zotero-cita";
  version = "1.0.0-beta.24";

  src = fetchFromGitHub {
    owner = "zotero-cita";
    repo = "zotero-cita";
    tag = "v${version}";
    hash = "sha256-h5cNa0qIONTkU86I2zg6HIqL/UtfwCQmh+le+bbN/W4=";
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

  npmDepsHash = "sha256-ct7T+9tN4qvJJ7Udb4Ommb8P9OIYYdnDHTPgGk/AtcI=";

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
    install -m444 -D build/*.xpi $out/share/zotero/extensions/zotero-cita.xpi
    runHook postInstall
  '';

  passthru.extensionId = "zotero-wikicite@wikidata.org";

  passthru.updateScript = nix-update-script {
    attrPath = "zotero-addons.zotero-cita";
    extraArgs = [ "--flake" ];
  };

  meta = with lib; {
    description = "Cita: a Wikidata addon for Zotero with citations metadata support";
    homepage = "https://github.com/zotero-cita/zotero-cita";
    license = licenses.gpl3Only;
    platforms = platforms.all;
  };
}
