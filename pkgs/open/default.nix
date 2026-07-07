{
  writeShellScriptBin,
  lib,
  xdg-utils,
}:
let
  xdgopen = lib.getExe' xdg-utils "xdg-open";
in
(writeShellScriptBin "open" ''
  ((${xdgopen} "$@") &>/dev/null) &
  disown %1
'').overrideAttrs
  (_: {
    meta = {
      description = "Compatibility shim to allow `open` on non-darwin to behave like darwin";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  })
