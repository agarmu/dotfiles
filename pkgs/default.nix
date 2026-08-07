pkgs:
let
  callPackage = pkgs.lib.callPackageWith pkgs;
in
{
  build-support = callPackage ./build-support { };

  calibre-bin = callPackage ./calibre-bin { };
  clipvault = callPackage ./clipvault { };
  firefox-addons = callPackage ./firefox-addons { };
  helium = callPackage ./helium { };
  imgblur = callPackage ./imgblur { };
  iosevka-kian = callPackage ./iosevka-kian { };
  iosevka-kian-bin = callPackage ./iosevka-kian-bin { };
  kent-class-download = callPackage ./kent-class-download { };
  lazymake = callPackage ./lazymake { };
  mkWallpaper = callPackage ./mkWallpaper { };
  niri-scripts = callPackage ./niri-scripts { };
  niri-shaders = callPackage ./niri-shaders { };
  niri-tweaks = callPackage ./niri-tweaks { };
  stinkpot = callPackage ./stinkpot { };
  omniwm = callPackage ./omniwm { };
  open = callPackage ./open { };
  pi-extensions = callPackage ./pi-extensions { };
  qman = callPackage ./qman { };
  slk = callPackage ./slk { };
  why = callPackage ./why { };
  zotero-addons = callPackage ./zotero-addons { };
}
