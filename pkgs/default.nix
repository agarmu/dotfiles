pkgs:
let
  callPackage = pkgs.lib.callPackageWith pkgs;
in
{
  build-support = callPackage ./build-support { };

  calibre-bin = callPackage ./calibre-bin { };
  clipvault = callPackage ./clipvault { };
  firefox-addons = callPackage ./firefox-addons { };
  helix-plugins = callPackage ./helix-plugins { };
  helium = callPackage ./helium { };
  imgblur = callPackage ./imgblur { };
  iosevka-kian = callPackage ./iosevka-kian { };
  iosevka-kian-bin = callPackage ./iosevka-kian-bin { };
  kpfonts = callPackage ./kpfonts { };
  kent-class-download = callPackage ./kent-class-download { };
  lazymake = callPackage ./lazymake { };
  mkWallpaper = callPackage ./mkWallpaper { };
  niri-scripts = callPackage ./niri-scripts { };
  niri-shaders = callPackage ./niri-shaders { };
  niri-tweaks = callPackage ./niri-tweaks { };
  stinkpot = callPackage ./stinkpot { };
  tytanic = callPackage ./tytanic { };
  omniwm = callPackage ./omniwm { };
  omry-cli = callPackage ./omry-cli { };
  omry-server = callPackage ./omry-server { };
  open = callPackage ./open { };
  papercut = callPackage ./papercut { };
  perspec = callPackage ./perspec { };
  prequery = callPackage ./prequery { };
  qman = callPackage ./qman { };
  slk = callPackage ./slk { };
  why = callPackage ./why { };
  zotero-addons = callPackage ./zotero-addons { };
}
