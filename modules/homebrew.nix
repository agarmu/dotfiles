{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    coreutils
    git
  ];
  environment.variables = {
    HOMEBREW_NO_ANALYTICS = "1";
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

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

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
      "oven-sh/bun"
    ];

    brews = [
      "homebank"
      "openjdk"
      "openssh"
      "bun"
      "llvm"
      "exiftool"
      "meson"
      "pandoc"
      "ykman"
      "libiconv"
      "llvm"
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
      "vscodium"
      "xournal-plus-plus"
      "zoom"
      "zotero"
    ];
  };
}
