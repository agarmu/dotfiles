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
    mercurial
    subversion
    darcs
    jujutsu

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
    wget
    wget2
    curl # Of course, the generic networking utilities

    ##########################
    # Editors & Multiplexers #
    ##########################
    zellij # Rusty terminal multiplexer
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
    ripgrep # Grep alternative
    yt-dlp # Download media from YouTube and similar
    nnn # Small file browser
    parallel # GNU Tool to execute commands in parallel
    qrencode # Works with qr codes
    scc # Code Complexity analysis
    file # Gets file type
    which # Gets executable path
    gnused # GNU version of sed
    gnutar # GNU version of tar
    gawk # GNU version of AWK
    zola # Static site generator
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
    commitizen # Formats commits
    lazygit # Git UI for terminal
    # TODO Move Valgrind to Homebrew -- broken on nix for mac
    # valgrind # Memory Profiler
    hyperfine # Terminal benchmarking utility
    wasm-pack # Packages an application for WASM
    mold # Drop-in ld replacement
    ghidra # Reverse-engineering tool developed by the NSA
    qemu # emulator & virtualizer
    #################
    # Build Systems #
    #################
    cmake
    gnumake
    ninja
    meson
    just
    bazel_7

    ##############################
    # Programming Languages/SDKs #
    ##############################

    deno # Fast JS Runtime
    fnm # Fast Node Version Management
    opam # OCaml Version/Package Management
    rustup # Rust management software
    jdk21 # OpenJDK 21
    maven # Maven
    lean4 # Lean theorem prover
    coq # Coq theorem prover
    elixir # Elixir language
    elixir-ls # LSP for elixir
    nodePackages.bash-language-server # bash lsp
    nodePackages.vscode-css-languageserver-bin # css lsp

    ##############
    # SaaS Tools #
    ##############
    flyctl
    cloudflared
    netlify-cli

    ############
    # Security #
    ############
    gnupg

    ##############
    # Typsetting #
    ##############

    ## TeX
    texlive.combined.scheme-full # TeX/LaTeX Distribution
    texlab # TeX lsp

    ## Typst
    typst
    typst-lsp

    ########
    # Misc #
    ########
    fswatch # Watch filesystem for changes
    neofetch
    hyfetch
    freshfetch # Pretty Terminals
    plantuml # Nice Diagramming
    graphviz # Graph visualization
    #############
    # Databases #
    #############
    sqlite # Embedded SQL Database
    postgresql # Postgres SQL database
  ];
}
