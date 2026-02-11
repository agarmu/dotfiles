_: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    casks = [
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
      "aerospace" # Window Manager!
      "bitwarden"
      "whatsapp"
      "slack"
      "cursor"

      "mos" # for mouse
    ];
  };
}
