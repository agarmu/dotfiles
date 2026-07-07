{
  lib,
  stdenv,
  makeBinaryWrapper,
  callPackage,
  nix-update-script,
}:
let
  version = "9.10.0";
  hash = "sha256-aKCRpCBzUYQtpQn7oKvsmvu4Mkmfh1Lm/NmWQlstqII=";
  calibre-unwrapped = callPackage ./calibre-unwrapped.nix { inherit version hash; };
  realApp = "${calibre-unwrapped}/Applications/calibre.app";
  realMacOS = "${realApp}/Contents/MacOS";
  installables = [
    "calibre"
    "calibre-complete"
    "calibre-customize"
    "calibre-debug"
    "calibre-parallel"
    "calibre-server"
    "calibre-smtp"
    "calibredb"
    "ebook-convert"
    "ebook-device"
    "ebook-edit"
    "ebook-meta"
    "ebook-polish"
    "ebook-viewer"
    "fetch-ebook-metadata"
    "lrf2lrs"
    "lrfviewer"
    "lrs2lrf"
    "markdown-calibre"
    "web2disk"
  ];
  wrapperCommands = lib.concatMapStringsSep "\n" (name: ''
    makeBinaryWrapper "${realMacOS}/${name}" "$app/Contents/MacOS/${name}"
    makeBinaryWrapper "${realMacOS}/${name}" "$out/bin/${name}"
  '') installables;
in
stdenv.mkDerivation {
  pname = "calibre";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ calibre-unwrapped ];

  installPhase = ''
    runHook preInstall

    app=$out/Applications/calibre.app
    mkdir -p "$app/Contents/MacOS"
    mkdir -p "$app/Contents/Resources"
    mkdir -p "$out/bin"

    # Copy bundle metadata/resources so macOS recognises the bundle and shows
    # the normal calibre icon. Avoid copying Frameworks, PlugIns, and nested
    # helper apps here; the wrapper should stay copyApps-safe.
    cp "${realApp}/Contents/Info.plist" "$app/Contents/Info.plist"
    cp -R "${realApp}/Contents/Resources/." "$app/Contents/Resources/"

    # Binary wrappers that exec the real calibre binaries.
    # The real binaries resolve their @rpath/@loader_path relative to their own
    # locations in the nix store, so they find their Frameworks there.
    ${wrapperCommands}

    runHook postInstall
  '';

  meta = {
    description = "Calibre (wrapped, copyApps-safe bundle)";
    platforms = lib.platforms.darwin;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "calibre-bin";
    extraArgs = [
      "--flake"
      "--url"
      "https://github.com/kovidgoyal/calibre"
    ];
  };
}
