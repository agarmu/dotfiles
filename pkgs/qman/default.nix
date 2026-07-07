{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  ncurses,
  groff,
  python3Packages,
  man-db,
  xdg-utils,
  nix-update-script,
  # Optional dependencies
  zlib,
  bzip2,
  xz,
  # Test dependencies
  cunit,
  # Options
  enableTests ? false, # broken: qman_tests_list.sh fails to execute during meson configure
  enableGzip ? true,
  enableBzip2 ? true,
  enableLzma ? true,
}:

stdenv.mkDerivation rec {
  pname = "qman";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "plp13";
    repo = "qman";
    rev = "v${version}";
    hash = "sha256-z3ILbbwcCYZT8qabVaGnMCyZRag8djEI32i6G7cLL2A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.cogapp
  ];

  buildInputs = [
    ncurses
    groff
  ]
  ++ lib.optionals enableGzip [
    zlib
  ]
  ++ lib.optionals enableBzip2 [
    bzip2
  ]
  ++ lib.optionals enableLzma [
    xz
  ]
  ++ lib.optionals enableTests [
    cunit
  ];

  mesonFlags = [
    (lib.mesonEnable "tests" enableTests)
    (lib.mesonEnable "libbsd" false)
    (lib.mesonEnable "gzip" enableGzip)
    (lib.mesonEnable "bzip2" enableBzip2)
    (lib.mesonEnable "lzma" enableLzma)
    # Use standard Nix paths
    "-Ddocdir=${placeholder "out"}/share/doc/qman"
    "-Dconfigdir=${placeholder "out"}/etc/xdg/qman"
  ];

  # Patch hardcoded paths in config_def.py before build
  postPatch = ''
    substituteInPlace src/config_def.py \
      --replace-fail '"/usr/bin/man"' '"${man-db}/bin/man"' \
      --replace-fail '"/usr/bin/groff"' '"${groff}/bin/groff"' \
      --replace-fail '"/usr/bin/whatis"' '"${man-db}/bin/whatis"' \
      --replace-fail '"/usr/bin/apropos"' '"${man-db}/bin/apropos"' \
      --replace-fail '"/usr/bin/xdg-open"' '"${xdg-utils}/bin/xdg-open"' \
      --replace-fail '"/usr/bin/xdg-email"' '"${xdg-utils}/bin/xdg-email"'
    chmod +x src/qman_tests_list.sh
  '';

  doCheck = enableTests;

  meta = with lib; {
    description = "A more modern manual page viewer for our terminals";
    longDescription = ''
      Qman is a modern, full-featured manual page viewer featuring hyperlinks,
      web browser like navigation, a table of contents for each page,
      incremental search, on-line help, and more. It strives to be fast and
      tiny, so that it can be used everywhere.
    '';
    homepage = "https://github.com/plp13/qman";
    changelog = "https://github.com/plp13/qman/releases/tag/v${version}";
    license = licenses.bsd2;
    platforms = platforms.unix;
    mainProgram = "qman";
  };

  passthru.updateScript = nix-update-script {
    attrPath = "qman";
    extraArgs = [ "--flake" ];
  };
}
