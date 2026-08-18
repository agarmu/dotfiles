{
  lib,
  stdenvNoCC,
}:

lib.makeOverridable (
  {
    pluginName ? null,
    pluginDependencies ? [ ],
    native ? null,
    ...
  }@args:
  let
    cogName = if pluginName == null then lib.removeSuffix ".hx" args.pname else pluginName;
    derivationArgs = removeAttrs args [
      "pluginName"
      "pluginDependencies"
      "native"
    ];
  in
  stdenvNoCC.mkDerivation (
    derivationArgs
    // {
      strictDeps = args.strictDeps or true;
      __structuredAttrs = args.__structuredAttrs or true;
      dontConfigure = args.dontConfigure or true;
      dontBuild = args.dontBuild or true;

      installPhase =
        args.installPhase or ''
          runHook preInstall
          find . -name '*.scm' -type f -exec install -Dm644 {} "$out/{}" \;
          runHook postInstall
        '';

      doInstallCheck = args.doInstallCheck or true;
      installCheckPhase =
        args.installCheckPhase or ''
          runHook preInstallCheck
          find "$out" -type f -name '*.scm' -print -quit | grep -q .
          runHook postInstallCheck
        '';

      passthru = (args.passthru or { }) // {
        # nhx uses Steel's "cog" name for the directory under
        # $STEEL_HOME/cogs and for generated require paths.
        inherit cogName native pluginDependencies;
      };
    }
  )
)
