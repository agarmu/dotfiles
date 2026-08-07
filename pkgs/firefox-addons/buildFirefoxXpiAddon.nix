{
  lib,
  jq,
  moreutils,
  stdenvNoCC,
  unzip,
  web-ext,
  zip,
}:

lib.makeOverridable (
  {
    pname,
    version,
    addonId,
    src,
    meta ? { },
    ...
  }:
  stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      jq
      moreutils
      unzip
      web-ext
      zip
    ];

    unpackPhase = ''
      runHook preUnpack
      mkdir -p addon
      unzip -q "$src" -d addon
      runHook postUnpack
    '';

    patchPhase = ''
      runHook prePatch
      jq '
        del(.applications.gecko.update_url, .browser_specific_settings.gecko.update_url)
        | .browser_specific_settings.gecko.data_collection_permissions = {"required": ["none"]}
      ' addon/manifest.json | sponge addon/manifest.json
      rm -rf addon/META-INF addon/mozilla-recommendation.json
      runHook postPatch
    '';

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild
      (cd addon && zip -qr ../addon.xpi .)
      runHook postBuild
    '';

    doCheck = true;
    checkPhase = ''
      runHook preCheck
      NO_UPDATE_NOTIFIER=1 web-ext lint --source-dir addon
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
      mkdir -p "$dst"
      install -v -m644 addon.xpi "$dst/${addonId}.xpi"
      runHook postInstall
    '';

    preferLocalBuild = true;
    allowSubstitutes = true;

    passthru = {
      inherit addonId;
    };
  }
)
