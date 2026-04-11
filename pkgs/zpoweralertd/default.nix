{
  lib,
  stdenv,
  fetchgit,
  zig,
  pkg-config,
  basu,
}:
stdenv.mkDerivation {
  pname = "zpoweralertd";
  version = "0-unstable-2026-04-11";

  src = fetchgit {
    url = "https://codeberg.org/mrus/zpoweralertd";
    rev = "3466ae9d7621cd459e6389dbef7b6a7fcbb37034";
    hash = "sha256-O+TW6q0aIdb6znJzfSVytrsrATZ0g8ZwinDItqd98hY=";
  };

  nativeBuildInputs = [
    zig.hook
    pkg-config
  ];

  buildInputs = [ basu ];

  meta = {
    description = "Drop-in replacement for poweralertd written in Zig";
    homepage = "https://codeberg.org/mrus/zpoweralertd";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "zpoweralertd";
  };
}
