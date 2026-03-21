{ lib, ... }:
{
  flake.modules.nixos.base.nixpkgs.overlays = [
    (
      final: prev:
      let
        blur-image = final.writeShellScript "blur-image" ''
          ${lib.getExe final.imagemagick} convert "$1" -scale 2% -blur 0x.5 -resize 5000% "$2"
        '';

        modulate-image = final.writeShellScript "modulate-image" ''
          ${lib.getExe final.imagemagick} convert "$1" -modulate 100,100,14 "$2"
        '';

        blurred-locker = final.writeShellScript "blurred-locker" ''
          # Skip if already locked
          ${final.procps}/bin/pgrep -x swaylock && exit 0

          LOCK_DIR=$(mktemp -d /tmp/locker-XXXXXX)
          SWAYLOCK_ARGS=""

          for output in $(${lib.getExe final.niri-unstable} msg --json outputs | ${lib.getExe final.jq} -r '.[].name'); do
            SCREENSHOT="$LOCK_DIR/$output.png"
            BLURRED="$LOCK_DIR/$output-blurred.png"
            ${lib.getExe final.grim} -o "$output" "$SCREENSHOT"
            ${blur-image} "$SCREENSHOT" "$BLURRED"
            SWAYLOCK_ARGS="$SWAYLOCK_ARGS -i $output:$BLURRED"
          done

          ${lib.getExe final.niri-unstable} msg action do-screen-transition 2>/dev/null || true

          # Run swaylock in foreground (no --daemonize), clean up after unlock
          ${lib.getExe final.swaylock} --no-daemonize $SWAYLOCK_ARGS
          rm -rf "$LOCK_DIR"
        '';
      in
      {
        bgutils = final.writeShellScriptBin "bgutils" ''
          case "$1" in
            blur)        shift; exec ${blur-image} "$@" ;;
            modulate)    shift; exec ${modulate-image} "$@" ;;
            lock)        shift; exec ${blurred-locker} "$@" ;;
            *)
              echo "Usage: bgutils {blur|modulate|lock} [args...]" >&2
              exit 1
              ;;
          esac
        '';
      }
    )
  ];
}
