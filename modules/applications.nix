_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    masApps = {
      # Apple Office
      "Pages" = 409201541;
      "Keynote" = 409183694;
    };

    taps = [
      "nikitabobko/tap" # for aerospace
      "parksb/x" # for collie
    ];

    brews = [
      "ykman"
      "llvm"
      "lld" # llvm linker
      # "gdb"
      # "valgrind"
      "pkg-config" # needed for UniMath
      "tailscale"
      "pinentry-mac" # gpg pinentry
      "uv" # python
      "oci-cli"
    ];

    casks = [
      "collie" # RSS Reader
      "vlc" # Video Player
      "anki" # Spaced Repetition
      "calibre" # E-Book Manager
      "coconutbattery" # macOS Battery Health Checker
      "chromium" # Lite Chrome-based Web-browser
      "zen" # Main Browser
      "free-gpgmail" # GPG tools for macOS
      "hammerspoon" # Custom OS extensions/keybinds
      "inkscape" # Vector Graphics Editor
      "darktable"
      "rawtherapee" # image editing
      "julia-app"
      "ghostty" # New Terminal Emulator
      "qbittorrent" # Torrent Client
      "skim" # PDF Viewer with Hot Reload
      "spotify" # Music Streaming
      "visual-studio-code"
      "zed" # yippee editor
      "zoom" # Video meeting tool
      "zotero" # Reference management tool
      "raycast" # Launcher
      "obsidian"
      "zulip" # for UniMath
      "sage" # Sagemath
      "aerospace" # Window Manager!
      "bitwarden"
      "whatsapp"
      "slack"
      "cursor"
      "microsoft-teams"
      "microsoft-word"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-onenote"
      "mos" # for mouse
    ];
  };
}
