{
  lib,
  runCommand,
  imgblur,
}:
{
  src,
  name ? null,
}:
let
  basename = baseNameOf (toString src);
  ext = lib.last (lib.splitString "." basename);
  stem = lib.removeSuffix ".${ext}" basename;
  effectiveName = if name != null then name else stem;
in
runCommand effectiveName { } ''
  mkdir -p $out
  cp ${src} $out/original.${ext}
  ${lib.getExe imgblur} ${src} $out/blurred.${ext}
''
