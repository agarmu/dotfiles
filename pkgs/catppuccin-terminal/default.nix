{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  build-support,
  font ? null,
  fontSize ? 12,
}:
assert lib.assertMsg (
  font == null || stdenvNoCC.hostPlatform.isDarwin
) "catppuccin-terminal: preparing a font requires macOS";
assert lib.assertMsg (
  builtins.isInt fontSize || builtins.isFloat fontSize
) "catppuccin-terminal: fontSize must be a number";
assert lib.assertMsg (fontSize > 0) "catppuccin-terminal: fontSize must be positive";
stdenvNoCC.mkDerivation {
  pname = "catppuccin-terminal";
  version = "0-unstable-2024-09-02";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "Terminal.app";
    rev = "671f4e176c6223e66995a1d30d7ddd4e736721af";
    hash = "sha256-KezTwq/vZiqb6crphPgfSltpKzBBzqdQb++oL915fhg=";
  };

  nativeBuildInputs = lib.optional (font != null) build-support.plist-font-patcher;

  buildPhase = ''
    runHook preBuild
      mkdir -p "$out/share/terminal"
  ''
  + lib.optionalString (font != null) ''
      for profile in themes/*.terminal; do
        plist-font-patcher "$profile" "$out/share/terminal/$(basename "$profile")" \
        ${lib.escapeShellArg (toString font)} ${lib.escapeShellArg (toString fontSize)}
    done
  ''
  + lib.optionalString (font == null) ''
    cp themes/*.terminal "$out/share/terminal/"
  ''
  + ''
    runHook postBuild
  '';
  dontInstall = true;

  meta = {
    description = "Catppuccin profiles for macOS Terminal";
    homepage = "https://github.com/catppuccin/Terminal.app";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
