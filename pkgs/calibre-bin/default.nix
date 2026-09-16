{
  lib,
  fetchurl,
  stdenv,
  darwin,
  makeBinaryWrapper,
  nix-update-script,
}:
let
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
in
stdenv.mkDerivation rec {
  pname = "calibre";
  version = "9.14.0";
  src = fetchurl {
    url = "https://download.calibre-ebook.com/${version}/calibre-${version}.dmg";
    hash = "sha256-ovglE4ZF6inZ93p4wXchbA24VfoMe5k6FqziMMBP49Q=";
  };

  nativeBuildInputs = [
    darwin.sigtool
    makeBinaryWrapper
  ];

  sourceRoot = ".";

  # APFS -- requires use of hdiutil
  # see the below link:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/lm/lmstudio/darwin.nix
  unpackCmd = ''
    echo "Creating temp directory"
    mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)
    function finish {
      echo "Ejecting temp directory"
      /usr/bin/hdiutil detach $mnt -force
      rm -rf $mnt
    }
    # Detach volume when receiving SIG "0"
    trap finish EXIT
    # Mount DMG file
    echo "Mounting DMG file into \"$mnt\""
    /usr/bin/hdiutil attach -nobrowse -mountpoint $mnt $curSrc
    # Copy content to local dir for later use
    echo 'Copying extracted content into "sourceRoot"'
    cp -a $mnt/calibre.app $PWD/
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    app=$out/Applications/calibre.app
    realApp=$out/libexec/calibre.app
    realMacOS=$realApp/Contents/MacOS

    mkdir -p "$out/Applications" "$out/libexec" "$app/Contents/MacOS"
    mkdir -p "$app/Contents/Resources" "$out/bin"

    # Keep the complete app outside Applications so the visible bundle remains
    # copyApps-safe. The wrappers execute the binaries from this location.
    cp -R calibre.app "$out/libexec/"

    # Re-sign the main executable, otherwise macOS reports the app as damaged.
    codesign --force --sign - "$realApp/Contents/MacOS/calibre"

    # Copy bundle metadata/resources so macOS recognises the bundle and shows
    # the normal calibre icon. Avoid copying Frameworks, PlugIns, and nested
    # helper apps into the visible bundle.
    cp calibre.app/Contents/Info.plist "$app/Contents/Info.plist"
    cp -R calibre.app/Contents/Resources/. "$app/Contents/Resources/"

    # Binary wrappers that exec the real calibre binaries.
    # The real binaries resolve their @rpath/@loader_path relative to their own
    # locations in the nix store, so they find their Frameworks there.
    ${lib.concatMapStringsSep "\n" (name: ''
      makeBinaryWrapper "$realMacOS/${name}" "$app/Contents/MacOS/${name}"
      makeBinaryWrapper "$realMacOS/${name}" "$out/bin/${name}"
    '') installables}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    test -f "$out/Applications/calibre.app/Contents/Info.plist"
    test -x "$out/libexec/calibre.app/Contents/MacOS/calibre"
    ${lib.concatMapStringsSep "\n" (name: ''
      test -x "$out/Applications/calibre.app/Contents/MacOS/${name}"
      test -x "$out/bin/${name}"
    '') installables}

    runHook postInstallCheck
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
      "--use-github-releases"
    ];
  };
}
