{pkgs, ...}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
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
    nix-tree # browse nix dependency tree

    /*
    ┌──────────────────────┐
    │ Editors & Text Tools │
    └──────────────────────┘
    */
    neovim # vim-derived editor
    emacs # emacs!

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
    php

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
    ┌─────────────────┐
    │ Developer Tools │
    └─────────────────┘
    */
    hyperfine # Terminal benchmarking utility
    wasm-pack # Packages an application for WASM
    qemu # emulator & virtualizer
    scc # Code Complexity analysis
    tree-sitter

    /*
    ┌──────────────┐
    │ Multiplexers │
    └──────────────┘
    */
    tmux # terminal multiplexer

    /*
    ┌────────────────┐
    │ System Monitor │
    └────────────────┘
    */
    htop # System monitor
    macchina # Fetch
    fswatch # Watch filesystem for changes

    /*
    ┌──────────────────────┐
    │ File & Text Utilities│
    └──────────────────────┘
    */
    fd # alternative to find utility
    ripgrep # Grep alternative
    eza # Better ls (fork of exa, which is no longer maintained)
    file # Gets file type
    which # Gets executable path
    gnused # GNU version of sed
    gnutar # GNU version of tar
    gawk # GNU version of AWK
    delta # nice diff viewer
    jq # Tool to work with json
    peco # interactive filtering/reading etc
    tldr # too-long; didn't read versions of `man' pages
    glow # CLI markdown previewer

    /*
    ┌─────────────┐
    │ Compression │
    └─────────────┘
    */
    zstd # fast real-time compression algo developed by facebook
    brotli # losless compression

    /*
    ┌────────────┐
    │ Networking │
    └────────────┘
    */
    openssh # SSH Agent
    sshfs # Mount remote filesystems
    sshuttle # evil vpn over ssh
    mosh # ssh alternative
    aria2 # CLI download utility
    socat # Better netcat
    wget2 # Web Get (v2)
    curl # client for URL
    rsync # fast remote sync
    inetutils
    nmap # Network Discovery tool
    gping # graph ping

    /*
    ┌───────────┐
    │ Databases │
    └───────────┘
    */
    sqlite # Embedded SQL Database

    /*
    ┌─────────────────┐
    │ Backup + DevOps │
    └─────────────────┘
    */
    terraform
    opentofu
    tofu-ls
    ansible
    google-cloud-sdk
    restic

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
    ┌──────────┐
    │ Spelling │
    └──────────┘
    */
    aspell
    aspellDicts.en
    aspellDicts.en-computers

    /*
    ┌─────────────────┐
    │ Media & Content │
    └─────────────────┘
    */
    imagemagick # Tooling to work with images
    exiftool # image exif data
    ffmpeg # Audio library/tool
    yt-dlp # Download media from YouTube and similar
    sioyek # pdf viewer

    /*
    ┌───────────────┐
    │ PDF Tools     │
    └───────────────┘
    */
    pdftk # PDF tool
    ghostscript # PDF Maniuplation
    poppler-utils # PDF Manipulation (Poppler)

    /*
    ┌───────────────────────────┐
    │ Formal Verification, etc. │
    └───────────────────────────┘
    */

    /*
    ┌──────────────┐
    │ Miscellaneous│
    └──────────────┘
    */
    qrencode # Works with qr codes
    parallel # GNU Parallel
    pv # progressbar
    hugo
  ];
}
