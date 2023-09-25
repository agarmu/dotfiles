{
  config,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask"
    ];
    brews = [
      "openjdk"
    ];
    casks = [
      "thunderbird"
      "firefox"
      "anaconda"
      "adobe-acrobat-pro"
      "anki"
      "calibre"
      "docker"
      "eagle"
      "hammerspoon"
      "inkscape"
      "gimp"
      "insomnia"
      "logseq"
      "maccy"
      "mochi"
      "qbittorrent"
      "raspberry-pi-imager"
      "signal"
      "skim"
      "spotify"
      "veracrypt"
      "vlc"
      "xournal-plus-plus"
      "zoom"
      "zotero"
      "anaconda"
    ];

    masApps = {
      # Microsoft Office
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Microsoft PowerPoint" = 462062816;

      # Apple Office
      "Pages" = 409201541;

      # Communications
      "Slack" = 803453959;
      "WhatsApp" = 1147396723;

      # Miscellaneous
      "GeoGebra Calculator Suite" = 1504416652;
    };
  };
}
