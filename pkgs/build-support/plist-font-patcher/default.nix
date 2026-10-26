{
  lib,
  stdenvNoCC,
  swift,
  swiftPackages,
  apple-sdk,
}:
stdenvNoCC.mkDerivation {
  pname = "plist-font-patcher";
  version = "1";

  src = ./main.swift;
  dontUnpack = true;

  nativeBuildInputs = [ swift ];
  buildInputs = [ apple-sdk ];

  buildPhase = ''
    runHook preBuild
    ${swift}/bin/swiftc -sdk "$SDKROOT" \
      -target ${stdenvNoCC.hostPlatform.swift.triple} \
      -L ${lib.getDev swiftPackages.stdlib}/lib \
      -module-cache-path "$TMPDIR/swift-module-cache" \
      "$src" -o plist-font-patcher
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 plist-font-patcher "$out/bin/plist-font-patcher"
    runHook postInstall
  '';

  meta = {
    description = "Set an archived NSFont in a plist from a font file and point size";
    mainProgram = "plist-font-patcher";
    platforms = lib.platforms.darwin;
  };
}
