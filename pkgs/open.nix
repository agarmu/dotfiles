{
  writeShellScriptBin,
  lib,
  xdg-utils,
}:
let
  xdgopen = lib.getExe' xdg-utils "xdg-open";
in
writeShellScriptBin "open" ''
  ((${xdgopen} "$@") &>/dev/null) &
  disown %1
''
