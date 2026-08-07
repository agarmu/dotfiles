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
    addonId,
    ...
  }@args:
  stdenvNoCC.mkDerivation (
    args
    // {
      nativeBuildInputs = [
        jq
        moreutils
        unzip
        web-ext
        zip
      ]
      ++ (args.nativeBuildInputs or [ ]);

      unpackPhase =
        args.unpackPhase or ''
          runHook preUnpack
          mkdir -p addon
          unzip -q "$src" -d addon
          runHook postUnpack
        '';

      patchPhase =
        args.patchPhase or ''
          runHook prePatch
          jq '
            del(.applications.gecko.update_url, .browser_specific_settings.gecko.update_url)
            | .browser_specific_settings.gecko.data_collection_permissions = {"required": ["none"]}
          ' addon/manifest.json | sponge addon/manifest.json
          rm -rf addon/META-INF addon/mozilla-recommendation.json
          runHook postPatch
        '';

      dontConfigure = args.dontConfigure or true;

      buildPhase =
        args.buildPhase or ''
          runHook preBuild
          (cd addon && zip -qr ../addon.xpi .)
          runHook postBuild
        '';

      doCheck = args.doCheck or true;
      checkPhase =
        args.checkPhase or ''
          runHook preCheck
          NO_UPDATE_NOTIFIER=1 web-ext lint --source-dir addon
          runHook postCheck
        '';

      installPhase =
        args.installPhase or ''
          runHook preInstall
          dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
          mkdir -p "$dst"
          install -v -m644 addon.xpi "$dst/${addonId}.xpi"
          runHook postInstall
        '';

      preferLocalBuild = args.preferLocalBuild or true;
      allowSubstitutes = args.allowSubstitutes or true;

      passthru = (args.passthru or { }) // {
        inherit addonId;
      };
    }
  )
)
