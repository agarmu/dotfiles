{
  writeShellScriptBin,
  lib,
  ffmpeg-headless,
}:
writeShellScriptBin "imgblur" ''
  FORMAT_ARGS=""
  if [ "$1" = "-f" ]; then
    FORMAT_ARGS="-f $2"
    shift 2
  fi
  ${lib.getExe ffmpeg-headless} -loglevel error $FORMAT_ARGS -i "''${1:--}" \
    -vf "gblur=sigma=''${IMGBLUR_SIGMA:-50}" \
    -y "$2"
''
