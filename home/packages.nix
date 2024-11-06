{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
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
    git                         # most popular vcs

    /*
    ┌─────────────┐
    │ Nix Tooling │
    └─────────────┘
    */
    alejandra                   # Formatter for Nix
    nixd                        # lsp
    deadnix                     # dead code detection
    statix                      # static analysis
    /*
    ┌────────────┐
    │ Networking │
    └────────────┘
    */
    openssh                     # SSH Agent
    sshfs                       # Mount remote filesystems
    aria                        # CLI download utility
    socat                       # Better netcat
    wget2                       # Web Get (v2)
    curl                        # client for URL

    /*
    ┌──────────────┐
    │ Multiplexers │
    └──────────────┘
    */
    tmux                        # terminal multiplexer

    /*
    ┌─────────────┐
    │ Compression │
    └─────────────┘
    */
    zstd                        # fast real-time compression algo developed by facebook
    brotli                      # losless compression

    /*
    ┌─────────────────┐
    │ Tools/Utilities │
    └─────────────────┘
    */
    delta                       # nice diff viewer
    fd                          # alternative to find utility
    jq                          # Tool to work with json
    nmap                        # Network Discovery tool
    glow                        # CLI markdown previewer
    eza                         # Better ls (fork of exa, which is no longer maintained)
    htop                        # System monitor
    btop                        # Better htop
    ripgrep                     # Grep alternative
    yt-dlp                      # Download media from YouTube and similar
    qrencode                    # Works with qr codes
    scc                         # Code Complexity analysis
    file                        # Gets file type
    which                       # Gets executable path
    gnused                      # GNU version of sed
    gnutar                      # GNU version of tar
    gawk                        # GNU version of AWK
    imagemagick                 # Tooling to work with images
    pdftk                       # PDF tool
    ffmpeg                      # Audio library/tool
    tree-sitter
    tldr                        # too-long; didn't read versions of `man' pages
    neovim                      # vim-derived editor
    peco                        # interactive filtering/reading etc
    /*
    ┌─────────────────┐
    │ Developer Tools │
    └─────────────────┘
    */
    hyperfine                   # Terminal benchmarking utility
    wasm-pack                   # Packages an application for WASM
    rizin                       # Fork of radare2 reverse-engineering tooling
    qemu                        # emulator & virtualizer
    ledger
    ghostscript
    /*
    ┌───────────────┐
    │ Build Systems │
    └───────────────┘
    */
    cmake
    gnumake
    just

    /*
    ┌────────────────────────────┐
    │ Programming Languages/SDKs │
    └────────────────────────────┘
    */
    fnm # Fast Node Version Management
    rustup # Rust management software
    jdk21 # OpenJDK 21
    gprolog # GNU Prolog
    dotnet-sdk_8
    zig zls # Zig language
    /*
    ┌───────────────────────────┐
    │ Formal Verification, etc. │
    └───────────────────────────┘
    */
    lean4
    coq
    coqPackages.vscoq-language-server
    coqPackages.coq-lsp
    /*
    ┌──────────┐
    │ Security │
    └──────────┘
    */
    gnupg

    /*
    ┌─────────────────────┐
    │ Typesetting/Writing │
    └─────────────────────┘
    */

    # TeX
    texlive.combined.scheme-full # TeX/LaTeX Distribution
    texlab # tex lsp
    tectonic # TeX build tooling

    # Typst
    typst
    tinymist
    typstyle
    # inputs.typst-lsp.packages.${system}.default

    # Writing LSP
    ltex-ls
    marksman

    /*
    ┌───────┐
    │ Misc. │
    └───────┘
    */
    fswatch # Watch filesystem for changes
    neofetch
    hledger # Accounting Software
    gping # gnu ping
    /*
    ┌───────────┐
    │ Databases │
    └───────────┘

    */
    sqlite # Embedded SQL Database
  ];
}
