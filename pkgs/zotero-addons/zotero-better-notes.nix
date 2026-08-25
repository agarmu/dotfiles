{
  lib,
  buildNpmPackage,
  cacert,
  fetchFromGitHub,
  nodejs_22,
  python3,
  python3Packages,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "zotero-better-notes";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "windingwind";
    repo = "zotero-better-notes";
    tag = "v${version}";
    hash = "sha256-sgaUYGLEnTbg0zVNqmWkblOZUAiV8A0Y8lWV8C5us/w=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-/hPDnNTmBvMoz5zs+Y2TtT2Kd2NDC/cJb1l8HTyNNBw=";

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
    install -m444 -D build/*.xpi $out/share/zotero/extensions/zotero-better-notes.xpi
    runHook postInstall
  '';

  passthru.extensionId = "Knowledge4Zotero@windingwind.com";

  passthru.updateScript = nix-update-script {
    attrPath = "zotero-addons.zotero-better-notes";
    extraArgs = [ "--flake" ];
  };

  meta = with lib; {
    description = "Everything about note management. All in Zotero.";
    homepage = "https://github.com/windingwind/zotero-better-notes";
    license = licenses.agpl3Only;
    platforms = platforms.all;
  };
}
