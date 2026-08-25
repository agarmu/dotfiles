{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  patchelf,
  widevine-cdm,
  enableWidevine ? false,
  nix-update-script,
  # runtime deps (from ldd)
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  libxkbcommon,
  libgbm,
  libGL,
  nspr,
  nss,
  pango,
  systemd,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxcb,
}:
let
  version = "0.15.7.1";
  pname = "helium";

  libPath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    libxkbcommon
    libgbm
    libGL
    nspr
    nss
    pango
    systemd
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
  ];
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-arm64_linux.tar.xz";
    hash = "sha256-CYHUDYEMwe+2//4cDPMS2VqcRfbRJD0USDxDJ7kKu6Q=";
  };

  nativeBuildInputs = [
    patchelf
    makeWrapper
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -dm 755 $out/opt/helium
    cp -r . $out/opt/helium/

    # fix interpreter on ELF binaries
    for f in $out/opt/helium/helium \
              $out/opt/helium/helium_crashpad_handler \
              $out/opt/helium/chrome \
              $out/opt/helium/chromedriver; do
      [ -f "$f" ] || continue
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}:$out/opt/helium" \
        "$f"
    done

    ${lib.optionalString enableWidevine ''
      cp -a ${widevine-cdm}/share/google/chrome/WidevineCdm $out/opt/helium/
    ''}

    # icon
    install -Dm 644 $out/opt/helium/product_logo_256.png \
      $out/share/icons/hicolor/256x256/apps/helium.png

    # desktop entry
    install -Dm 644 $out/opt/helium/helium.desktop \
      $out/share/applications/helium.desktop
    substituteInPlace $out/share/applications/helium.desktop \
      --replace-fail 'Exec=helium' "Exec=$out/bin/helium"

    install -dm 755 $out/bin
    makeWrapper $out/opt/helium/helium $out/bin/helium \
      --prefix LD_LIBRARY_PATH : "${libPath}"

    runHook postInstall
  '';

  meta = {
    description = "Private, fast, and honest web browser based on Chromium";
    homepage = "https://github.com/imputnet/helium-linux";
    license = if enableWidevine then lib.licenses.unfree else lib.licenses.gpl3Only;
    mainProgram = pname;
    platforms = [ "aarch64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };

  passthru.updateScript = nix-update-script {
    attrPath = "helium";
    extraArgs = [ "--flake" ];
  };
}
