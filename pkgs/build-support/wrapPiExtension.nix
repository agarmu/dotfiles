{
  jq,
  pi-coding-agent,
}:

# Keep the result as the package derivation (rather than wrapping it in a new
# derivation), so consumers can use `overrideAttrs` to add package-specific
# phases such as tests.
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
    if [ ''${#extension_paths[@]} -ne 1 ]; then
      echo "Expected exactly one Pi extension in $out/package.json; found ''${#extension_paths[@]}" >&2
      exit 1
    fi

    extension_path="''${extension_paths[0]#./}"
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

    runHook postInstallCheck
  '';
  passthru = (old.passthru or { }) // {
    piExtensionCheck = "package.json:pi.extensions";
  };
})
