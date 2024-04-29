{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    ############
    # Spelling #
    ############
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    ##################
    # Custom scripts #
    ##################
    (buildEnv {
      name = "scripts";
      paths = [./scripts];
    })

    ############################
    # Version Control Software #
    ############################
    git

    #############
    # Nix Tools #
    #############
    alejandra # Formatter for Nix
    nil # LSP for nix

    ##############
    # Networking #
    ##############

    openssh # SSH Agent
    mosh # robust alternative to ssh
    aria # CLI download utility
    socat # Better netcat
    wget2
    curl

    ##########################
    # Editors & Multiplexers #
    ##########################
    tmux # Need I say more?

    ###############
    # Compression #
    ###############
    zstd
    brotli

    #############
    # CLI Tools #
    #############
    delta # nice diff viewer
    fd # alternative to find utility
    jq # Tool to work with json
    nmap # Network Discovery tool
    glow # CLI markdown previewer
    eza # Better ls (fork of exa, which is no longer maintained)
    htop # System monitor
    btop # Better htop
    ripgrep # Grep alternative
    yt-dlp # Download media from YouTube and similar
    qrencode # Works with qr codes
    scc # Code Complexity analysis
    file # Gets file type
    which # Gets executable path
    gnused # GNU version of sed
    gnutar # GNU version of tar
    gawk # GNU version of AWK
    inputs.datamine-scraper.packages.${system}.default # Datamine Scraper (by me)
    #############
    # Utilities #
    #############
    imagemagick # Tooling to work with images
    pdftk # PDF tool
    ffmpeg # Audio library/tool

    #####################
    # Developer Tooling #
    #####################
    # TODO Move Valgrind to Homebrew -- broken on nix for mac
    # valgrind # Memory Profiler
    hyperfine # Terminal benchmarking utility
    wasm-pack # Packages an application for WASM
    rizin # Fork of radare2 reverse-engineering tooling
    qemu # emulator & virtualizer
    #################
    # Build Systems #
    #################
    cmake
    gnumake
    just

    ##############################
    # Programming Languages/SDKs #
    ##############################

    fnm # Fast Node Version Management
    rustup # Rust management software
    jdk21 # OpenJDK 21
    nodePackages.bash-language-server # bash lsp
    nodePackages.vscode-css-languageserver-bin # css lsp
    gprolog # GNU Prolog
    dotnet-sdk_8
    omnisharp-roslyn # Roslyn OmniSharp LSP for .NET

    ############
    # Security #
    ############
    gnupg

    /*
    ┌─────────────────────┐
    │ Typesetting/Writing │
    └─────────────────────┘
    */

    # TeX
    texlive.combined.scheme-full # TeX/LaTeX Distribution

    # Typst
    inputs.typst.packages.${system}.default
    typst-lsp
    #    inputs.typst-lsp.packages.${system}.default

    # Writing LSP
    ltex-ls
    ########
    # Misc #
    ########
    fswatch # Watch filesystem for changes
    neofetch

    #############
    # Databases #
    #############
    sqlite # Embedded SQL Database
  ];
}
