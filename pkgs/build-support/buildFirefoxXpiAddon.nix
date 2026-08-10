{
  lib,
  stdenvNoCC,
}:

lib.makeOverridable (
  {
    addonId,
    ...
  }@args:
  stdenvNoCC.mkDerivation (
    args
    // {
      # Install the vendor XPI verbatim so its Mozilla signature remains valid.
      dontUnpack = args.dontUnpack or true;
      dontConfigure = args.dontConfigure or true;
      dontBuild = args.dontBuild or true;

      installPhase =
        args.installPhase or ''
          runHook preInstall
          dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
          mkdir -p "$dst"
          install -v -m644 "$src" "$dst/${addonId}.xpi"
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
