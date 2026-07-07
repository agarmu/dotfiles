{
  lib,
  stdenv,
  darwin,
  version,
  src,
}:
stdenv.mkDerivation {
  pname = "calibre-unwrapped";
  inherit version src;

  nativeBuildInputs = [
    darwin.sigtool
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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications/

    # Re-sign the main executable, otherwise macOS reports the app as damaged
    appBundle="$out/Applications/calibre.app"
    mainExe="$appBundle/Contents/MacOS/calibre"
    codesign --force --sign - "$mainExe"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Powerful and easy to use e-book manager";
    homepage = "https://calibre-ebook.com/";
    license = licenses.gpl2Only;
    platforms = platforms.darwin;
  };
}
