{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    coreutils
    binutils
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
      "null-dev/firefox-profile-switcher"
    ];

    brews = [
      "openjdk"
      "openssh"
      "bun"
      "exiftool"
      "meson"
      "pandoc"
      "ykman"
      "libiconv"
      "llvm"
      "gdb"
      "valgrind"
      "firefox-profile-switcher-connector"
      "julia"
      "opam"
    ];

    casks = [
      "parksb/x/collie"
      "iina"
      "tor-browser"
      "anaconda"
      "anki"
      "mochi" # spaced repetition
      "calibre"
      "coconutbattery"
      "cutter"
      "chromium"
      "docker"
      "firefox"
      "free-gpgmail"
      "godot"
      "hammerspoon"
      "handbrake"
      "inkscape"
      "kitty"
      "maccy"
      "qbittorrent"
      "gimp"
      "signal"
      "skim"
      "spotify"
      "thunderbird"
      "vlc"
      "vscodium"
      "zoom"
      "zotero"
      "calibre"
    ];
  };
}
