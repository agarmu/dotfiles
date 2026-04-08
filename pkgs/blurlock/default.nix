{
  writeShellScriptBin,
  lib,
  mukul,
  wlr-randr,
  gnugrep,
  grim,
  swaylock,
  procps,
}:
writeShellScriptBin "blurlock" ''
  # Skip if already locked
  ${procps}/bin/pgrep -x swaylock && exit 0

  if [ "$1" = "--live" ]; then
    LOCK_DIR=$(mktemp -d /tmp/locker-XXXXXX)
    SWAYLOCK_ARGS=""

    for output in $(${lib.getExe wlr-randr} | ${lib.getExe gnugrep} -oP '^\S+'); do
      BLURRED="$LOCK_DIR/$output-blurred.jpg"
      ${lib.getExe grim} -t ppm -o "$output" - | ${lib.getExe mukul.imgblur} -f image2pipe - "$BLURRED" &
      SWAYLOCK_ARGS="$SWAYLOCK_ARGS -i $output:$BLURRED"
    done
    wait

    ${lib.getExe swaylock} $SWAYLOCK_ARGS
  else
    WALLPAPER="''${1:-$HOME/.local/share/wallpapers/*/blurred.png}"
    ${lib.getExe swaylock} -i "$WALLPAPER"
  fi
''
