{
  jq,
  pi-coding-agent,
}:

{
  # Wrap a Pi extension package with an install-time smoke test.  The RPC
  # request initializes Pi without contacting a model, so this catches parse,
  # import, and registration failures without needing credentials or network.
  buildPiSubagent =
    {
      package,
    }:
    package.overrideAttrs (old: {
      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck
        export HOME="$TMPDIR/pi-home"
        export PI_CODING_AGENT_DIR="$TMPDIR/pi-home"
        mkdir -p "$HOME"

        mapfile -t extension_paths < <(${jq}/bin/jq -r '.pi.extensions[]? | strings' "$out/package.json")
        if [ ''${#extension_paths[@]} -eq 0 ]; then
          echo "No Pi extensions declared in $out/package.json" >&2
          exit 1
        fi

        for extension_path in "''${extension_paths[@]}"; do
          extension_path="''${extension_path#./}"
          extension_file="$out/$extension_path"
          if [ ! -f "$extension_file" ]; then
            echo "Pi extension declared by package.json is missing: $extension_file" >&2
            exit 1
          fi
          echo "Loading Pi extension: $extension_path"
          printf '%s\n' '{"type":"get_state"}' \
            | ${pi-coding-agent}/bin/pi \
                --offline \
                --no-session \
                --no-tools \
                --no-extensions \
                --extension "$extension_file" \
                --mode rpc \
                > "$TMPDIR/pi-rpc-response.json"
        done

        runHook postInstallCheck
      '';
      passthru = (old.passthru or { }) // {
        piExtensionCheck = "package.json:pi.extensions";
      };
    });
}
