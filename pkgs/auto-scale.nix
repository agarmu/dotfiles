{
  writeShellApplication,
  wlr-randr,
  gnugrep,
  coreutils,
}:
writeShellApplication {
  name = "auto-scale";
  runtimeInputs = [
    wlr-randr
    gnugrep
    coreutils
  ];
  text = ''
    echo "auto-scale: starting" >&2
    info=$(wlr-randr)
    echo "auto-scale: wlr-randr output: $info" >&2
    output=$(echo "$info" | head -1 | cut -d' ' -f1)
    echo "auto-scale: detected output=$output" >&2

    # Extract current resolution width and physical width (mm)
    res_w=$(echo "$info" | grep -oP '\d+x\d+' | head -1 | cut -dx -f1)
    phys_w=$(echo "$info" | grep -oP 'Physical size: \K\d+') || true
    echo "auto-scale: res_w=$res_w phys_w=$phys_w" >&2

    # Compute DPI: pixels / (mm / 25.4)
    scale=1
    if [ -n "$phys_w" ] && [ "$phys_w" -gt 0 ]; then
      dpi=$(( res_w * 254 / phys_w / 10 ))
      echo "auto-scale: computed dpi=$dpi" >&2
      if [ "$dpi" -gt 150 ]; then
        scale=2
      fi
    fi

    echo "auto-scale: applying scale=$scale to output=$output" >&2
    wlr-randr --output "$output" --scale "$scale"
    echo "auto-scale: done" >&2
  '';
}
