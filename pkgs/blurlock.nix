{
  writeShellScriptBin,
  lib,
  imgblur,
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
    SCREENSHOT="$LOCK_DIR/$output.png"
    BLURRED="$LOCK_DIR/$output-blurred.png"
    ${lib.getExe grim} -o "$output" "$SCREENSHOT"
    ${lib.getExe imgblur} "$SCREENSHOT" "$BLURRED" &
    SWAYLOCK_ARGS="$SWAYLOCK_ARGS -i $output:$BLURRED"
  done
  wait

  ${lib.getExe niri-unstable} msg action do-screen-transition 2>/dev/null || true

  # Run swaylock in foreground, clean up after unlock
  ${lib.getExe swaylock} $SWAYLOCK_ARGS
  rm -rf "$LOCK_DIR"
''
