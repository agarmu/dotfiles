pkgs:
let
  callPackage = pkgs.lib.callPackageWith pkgs;
in
{
  build-support = callPackage ./build-support { };

  calibre-bin = callPackage ./calibre-bin { };
  catppuccin-terminal = callPackage ./catppuccin-terminal { };
  clipvault = callPackage ./clipvault { };
  firefox-addons = callPackage ./firefox-addons { };
  helium = callPackage ./helium { };
  imgblur = callPackage ./imgblur { };
  iosevka-kian = callPackage ./iosevka-kian { };
  iosevka-kian-bin = callPackage ./iosevka-kian-bin { };
  kpfonts = callPackage ./kpfonts { };
  # kent-class-download = callPackage ./kent-class-download { };
  # lazymake = callPackage ./lazymake { };
  mkWallpaper = callPackage ./mkWallpaper { };
  niri-scripts = callPackage ./niri-scripts { };
  niri-shaders = callPackage ./niri-shaders { };
  niri-tweaks = callPackage ./niri-tweaks { };
  nordwand-mono = callPackage ./nordwand-mono { };
  stinkpot = callPackage ./stinkpot { };
  tytanic = callPackage ./tytanic { };
  titillium-web = callPackage ./titillium-web { };
  # omniwm = callPackage ./omniwm { };
  omry-cli = callPackage ./omry-cli { };
  omry-server = callPackage ./omry-server { };
  open = callPackage ./open { };
  papercut = callPackage ./papercut { };
  pelton = callPackage ./pelton { };
  prequery = callPackage ./prequery { };
  # qman = callPackage ./qman { };
  slk = callPackage ./slk { };
  why = callPackage ./why { };
  # xournalpp-bin = callPackage ./xournalpp-bin { };
  zotero-addons = callPackage ./zotero-addons { };
}
