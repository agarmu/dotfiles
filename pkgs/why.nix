{
  writeShellScriptBin,
  lib,
  which,
  coreutils,
}:
let
  which' = lib.getExe which;
  readlink = lib.getExe' coreutils "readlink";
in
writeShellScriptBin "why" ''
  orig="$(${readlink} -f "$(${which'} "$1")")"
  drvdir="$(echo "$orig" | cut -d'/' -f1-4)"
  target="''${2:-/run/current-system}"
  nix why-depends "$target" "$drvdir"
''
