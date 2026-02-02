{pkgs, ...}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    /*
    ┌──────────┐
    │ Spelling │
    └──────────┘
    */
    aspell
    aspellDicts.en
    aspellDicts.en-computers

    /*
    ┌────────────────┐
    │ Custom scripts │
    └────────────────┘
    */
    (buildEnv {
      name = "scripts";
      paths = [./scripts];
    })

    /*
    ┌─────────────────┐
    │ Version Control │
    └─────────────────┘
    */
    git # most popular vcs
    lazygit # nicer ui for git
    jujutsu

    /*
    ┌─────────────┐
    │ Nix Tooling │
    └─────────────┘
    */
    alejandra # Formatter for Nix
    nixd # lsp
    deadnix # dead code detection
    statix # static analysis
    nix-search-cli
    /*
    ┌────────────┐
    │ Networking │
    └────────────┘
    */
    openssh # SSH Agent
    sshfs # Mount remote filesystems
    mosh # ssh alternative
    aria2 # CLI download utility
    socat # Better netcat
    wget2 # Web Get (v2)
    curl # client for URL
    rsync # fast remote sync
    inetutils

    /*
    ┌──────────────┐
    │ Multiplexers │
    └──────────────┘
    */
    tmux # terminal multiplexer

    /*
    ┌─────────────┐
    │ Compression │
    └─────────────┘
    */
    zstd # fast real-time compression algo developed by facebook
    brotli # losless compression

    /*
    ┌─────────────────┐
    │ Tools/Utilities │
    └─────────────────┘
    */
    delta # nice diff viewer
    fd # alternative to find utility
    jq # Tool to work with json
    nmap # Network Discovery tool
    glow # CLI markdown previewer
    eza # Better ls (fork of exa, which is no longer maintained)
    htop # System monitor
    ripgrep # Grep alternative
    yt-dlp # Download media from YouTube and similar
    qrencode # Works with qr codes
    scc # Code Complexity analysis
    file # Gets file type
    which # Gets executable path
    gnused # GNU version of sed
    gnutar # GNU version of tar
    gawk # GNU version of AWK
    imagemagick # Tooling to work with images
    exiftool # image exif data
    pdftk # PDF tool
    ffmpeg # Audio library/tool
    tree-sitter
    tldr # too-long; didn't read versions of `man' pages
    neovim # vim-derived editor
    emacs # emacs!
    peco # interactive filtering/reading etc
    /*
    ┌─────────────────┐
    │ Developer Tools │
    └─────────────────┘
    */
    hyperfine # Terminal benchmarking utility
    wasm-pack # Packages an application for WASM
    qemu # emulator & virtualizer
    ghostscript # PDF Maniuplation
    poppler-utils # PDF Manipulation (Poppler)
    /*
    ┌───────────────┐
    │ Build Systems │
    └───────────────┘
    */
    cmake # Very bad but must use
    gnumake # Often used badly
    just # More sane makefile
    meson # build tool

    /*
    ┌────────────────────────────┐
    │ Programming Languages/SDKs │
    └────────────────────────────┘
    */
    fnm # Fast Node Version Management
    deno # js runtime
    bun # js runtime
    rustup # Rust management software
    jdk # use lts jdk
    coursier # coursier! for scala!
    zig
    lua
    asm-lsp

    /*
    ┌───────────────────────────┐
    │ Formal Verification, etc. │
    └───────────────────────────┘
    */
    /*
    ┌──────────┐
    │ Security │
    └──────────┘
    */
    gnupg # GPG!!

    /*
    ┌─────────────────────┐
    │ Typesetting/Writing │
    └─────────────────────┘
    */

    # TeX
    texliveFull
    texlab # tex lsp
    tex-fmt
    # Typst
    typst
    typstyle

    /*
    ┌───────┐
    │ Misc. │
    └───────┘
    */
    fswatch # Watch filesystem for changes
    macchina # Fetch
    gping # graph ping
    parallel # GNU Parallel
    /*
    ┌───────────┐
    │ Databases │
    └───────────┘

    */
    sqlite # Embedded SQL Database

    /*
    other
    */
    php
    hugo
    /*
    ┌─────────────────┐
    │ Backup + Devops │
    └─────────────────┘
    */
    terraform
    opentofu
    tofu-ls
    ansible
    google-cloud-sdk
    restic

    /*
    misc.
    */
    pv # progressbar
  ];
}
