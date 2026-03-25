{
  writeShellScriptBin,
  lib,
  imagemagick,
}:
writeShellScriptBin "imgblur" ''
  ${lib.getExe imagemagick} "$1" -scale 2% -resize 5000% "$2"
''
