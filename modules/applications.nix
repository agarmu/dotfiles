{...}: {
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
    ];

    casks = [
      "collie" # RSS Reader
      "vlc" # Video Player
      "anki" # Spaced Repetition
      "calibre" # E-Book Manager
      "coconutbattery" # macOS Battery Health Checker
      "chromium" # Lite Chrome-based Web-browser
      "firefox" # Main Browser
      "free-gpgmail" # GPG tools for macOS
      "hammerspoon" # Custom OS extensions/keybinds
      "inkscape" # Vector Graphics Editor
      "julia-app"
      "ghostty" # New Terminal Emulator
      "qbittorrent" # Torrent Client
      "gimp" # GNU Image Manipulation Program
      "skim" # PDF Viewer with Hot Reload
      "spotify" # Music Streaming
      "visual-studio-code"
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

      "miniforge" # conda/mamba
      "mos" # for mouse
      "fontforge-app"
    ];
  };
}
