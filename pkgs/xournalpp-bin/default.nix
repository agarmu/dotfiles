{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  darwin,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenvNoCC.mkDerivation rec {
  pname = "xournalpp-bin";
  version = "1.3.8";

  src = fetchurl {
    url = "https://github.com/xournalpp/xournalpp/releases/download/v${version}/xournalpp-${version}-macOS-ARM64.dmg";
    sha256 = "7d992ef097afd6db304cb9df70615e67f1a1de412e06f7dc8f907fcde3b7d6d7";
  };

  nativeBuildInputs = [
    undmg
    makeBinaryWrapper
    darwin.autoSignDarwinBinariesHook
  ];

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R Xournal++.app "$out/Applications/"

    # xournalpp-wrapper is the executable invoked by Info.plist.
    makeBinaryWrapper "$out/Applications/Xournal++.app/Contents/MacOS/xournalpp-wrapper" \
      "$out/bin/xournalpp"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    attrPath = "xournalpp-bin";
    extraArgs = [ "--flake" ];
  };

  meta = {
    description = "Handwriting note-taking software with PDF annotation support";
    homepage = "https://xournalpp.github.io/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xournalpp";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
