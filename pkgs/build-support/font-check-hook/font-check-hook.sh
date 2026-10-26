fontCheckPhase() {
    runHook preInstallCheck

    local font
    local count=0
    local sanitizedFont
    sanitizedFont=$(mktemp --suffix=.otf)

    while IFS= read -r -d '' font; do
        echo "Validating font: $font"
        if ! ots-sanitize "$font" "$sanitizedFont"; then
            rm -f "$sanitizedFont"
            return 1
        fi
        count=$((count + 1))
    done < <(find -L "$out/share/fonts" -type f \( -iname '*.ttf' -o -iname '*.otf' \) -print0)

    rm -f "$sanitizedFont"
    if (( count == 0 )); then
        echo "No TTF or OTF fonts found in $out/share/fonts" >&2
        return 1
    fi

    runHook postInstallCheck
}

if [[ -z ${installCheckPhase-} ]]; then
    installCheckPhase=fontCheckPhase
fi
