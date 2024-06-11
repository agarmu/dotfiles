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
      "parksb/x/collie" # RSS Reader
      "vlc" # Video Player
      "iina" # Video Player
      "tor-browser" # Secure Browser
      "anaconda" # Python Package/Environment Manager
      "anki" # Spaced Repetition
      "mochi" # spaced repetition
      "calibre" # E-Book Manager
      "coconutbattery" # macOS Battery Health Checker
      "cutter" # Reverse-Engineering/Decompiling Tool
      "chromium" # Lite Chrome-based Web-browser
      "docker" # Containerization
      "firefox" # Main Browser
      "free-gpgmail" # GPG tools for macOS
      #"godot" # Gamedev toolchain
      "hammerspoon" # Custom OS extensions/keybinds
      "handbrake" # Nice frontend to ffmpeg
      "inkscape" # Vector Graphics Editor
      "kitty" # Terminal Emulator
      "qbittorrent" # Torrent Client
      "gimp" # GNU Image Manipulation Program
      "signal" # Secure E2E chat platform
      "skim" # PDF Viewer with Hot Reload
      "spotify" # Music Streaming
      "thunderbird" # E-Mail Client
      "vscodium" # FOSS version of VS Code
      "zoom" # Video meeting tool
      "zotero" # Reference management tool
      "neovide" # Neovim client
      "raycast" # Launcher
      "obsidian"
      "logseq" # Zettelkasten Notetaking Mechanism
      "rstudio"
    ];
  };
}
