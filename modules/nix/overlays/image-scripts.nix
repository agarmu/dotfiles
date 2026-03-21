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
          TMPDIR=$(mktemp -d /tmp/locker-XXXXXX)
          trap 'rm -rf "$TMPDIR"' EXIT

          SWAYLOCK_ARGS=""

          for output in $(${lib.getExe final.niri-unstable} msg --json outputs | ${lib.getExe final.jq} -r '.[].name'); do
            SCREENSHOT="$TMPDIR/$output.png"
            BLURRED="$TMPDIR/$output-blurred.png"
            ${lib.getExe final.grim} -o "$output" "$SCREENSHOT"
            ${blur-image} "$SCREENSHOT" "$BLURRED"
            SWAYLOCK_ARGS="$SWAYLOCK_ARGS -i $output:$BLURRED"
          done

          ${lib.getExe final.niri-unstable} msg action do-screen-transition 2>/dev/null || true
          exec ${lib.getExe final.swaylock} $SWAYLOCK_ARGS
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
