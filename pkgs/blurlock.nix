{
  writeShellScriptBin,
  lib,
  mukul,
  niri-unstable,
  jq,
  grim,
  swaylock,
  procps,
}:
writeShellScriptBin "blurlock" ''
  # Skip if already locked
  ${procps}/bin/pgrep -x swaylock && exit 0

  LOCK_DIR=$(mktemp -d /tmp/locker-XXXXXX)
  SWAYLOCK_ARGS=""

  for output in $(${lib.getExe niri-unstable} msg --json outputs | ${lib.getExe jq} -r '.[].name'); do
    BLURRED="$LOCK_DIR/$output-blurred.jpg"
    ${lib.getExe grim} -t ppm -o "$output" - | ${lib.getExe mukul.imgblur} -f image2pipe - "$BLURRED" &
    SWAYLOCK_ARGS="$SWAYLOCK_ARGS -i $output:$BLURRED"
  done
  wait

  ${lib.getExe swaylock} $SWAYLOCK_ARGS
''
