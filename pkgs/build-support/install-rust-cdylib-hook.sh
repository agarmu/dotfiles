installRustCdylibPhase() {
    runHook preInstall

    local libraryDirectory="target/@cargoShortTarget@/release"
    local libraries=("$libraryDirectory"/*@sharedLibrarySuffix@)

    if [[ ! -e "${libraries[0]}" ]]; then
        echo "no Rust cdylib found in $libraryDirectory" >&2
        return 1
    fi

    install -Dm755 "${libraries[@]}" -t "$out"

    runHook postInstall
}

installRustCdylibCheckPhase() {
    runHook preInstallCheck
    find "$out" -type f -name '*@sharedLibrarySuffix@' -print -quit | grep -q .
    runHook postInstallCheck
}

if [[ -z ${installPhase-} ]]; then
    installPhase=installRustCdylibPhase
fi

if [[ -z ${installCheckPhase-} ]]; then
    installCheckPhase=installRustCdylibCheckPhase
fi

doInstallCheck=1
