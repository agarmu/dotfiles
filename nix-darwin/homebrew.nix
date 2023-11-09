{
  config,
  pkgs,
  ...
}: {
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
    };
    taps = [
      "homebrew/cask"
      "oven-sh/bun"
    ];
    brews = [
      "openjdk"
      "openssh"
      "bun"
      "llvm"
      "exiftool"
      "meson"
      "pandoc"
      "ykman"
      "libiconv"
    ];
    casks = [
      "anaconda"
      "anki"
      "calibre"
      "coconutbattery"
      "cutter"
      "docker"
      "firefox"
      "free-gpgmail"
      "godot"
      "hammerspoon"
      "handbrake"
      "inkscape"
      "kitty"
      "krita"
      "livebook"
      "maccy"
      "qbittorrent"
      "scribus"
      "gimp"
      "signal"
      "skim"
      "spotify"
      "thunderbird"
      "vlc"
      "xournal-plus-plus"
      "zoom"
      "zotero"
    ];

    masApps = {
      # Microsoft Office
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Microsoft PowerPoint" = 462062816;
      "Onedrive" = 823766827;

      # Apple Office
      "Pages" = 409201541;
      "Keynote" = 409183694;
      # Communications
      "Slack" = 803453959;
      "WhatsApp" = 1147396723;

      # Miscellaneous
      "GeoGebra Calculator Suite" = 1504416652;
      "Tailscale" = 1475387142;
    };
  };
}
