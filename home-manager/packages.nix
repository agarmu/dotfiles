{
  config,
  pkgs,
  ...
}: {
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    #############
    # Nix Tools #
    #############
    alejandra # Formatter for Nix
    nil # LSP for nix

    ##############
    # Networking #
    ##############
    mosh # robust alternative to ssh
    aria # CLI download utility
    socat # Better netcat
    wget
    wget2 # Of course, the generic networking utilities

    ##########################
    # Editors & Multiplexers #
    ##########################
    helix # Post-modern vi
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
    spotify-tui # Because I like music

    file # Gets file type
    which # Gets executable path
    gnused # GNU version of sed
    gnutar # GNU version of tar
    gawk # GNU version of AWK

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

    #################
    # Build Systems #
    #################
    cmake
    gnumake
    ninja
    meson

    ##############################
    # Programming Languages/SDKs #
    ##############################

    gcc12 # GNU Compiler Collection v12
    deno # Fast JS Runtime
    fnm # Fast Node Version Management
    rustup # Rust management software

    ##########################
    # Communication Software #
    ##########################
    teams
    zoom-us

    ##############
    # SaaS Tools #
    ##############
    flyctl
    cloudflared
    wrangler
    heroku
    nodePackages.vercel
    netlify-cli
    awscli2
    oci-cli

    ############
    # Security #
    ############
    gnupg

    ##############
    # Typsetting #
    ##############

    ## LaTeX
    texlive.combined.scheme-full

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
  ];
}
