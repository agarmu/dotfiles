{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  rust-bin,
  pkg-config,
  openssl,
  makeWrapper,
  cacert,
  git,
  libiconv,
}:

let
  pname = "oh-my-pi";
  version = "13.2.1";
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "oh-my-pi";
    tag = "v${version}";
    hash = "sha256-ph98YH/RNFY87yS5o+i4qeT3j9IVCAnDC7eShCR+5GQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    bun
    rust-bin.nightly.latest.default
    pkg-config
    makeWrapper
    cacert
    git
  ];

  # Standard Apple frameworks are provided by the Darwin SDK through stdenv.
  buildInputs = [
    openssl
    libiconv
  ];

  dontConfigure = true;
  dontStrip = true;

  __noChroot = true;

  env = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  preBuild = ''
    export HOME=$(mktemp -d)

    git config --global user.email "nix@localhost"
    git config --global user.name "Nix Build"
    git config --global init.defaultBranch main

    export CARGO_HOME=$(mktemp -d)
    mkdir -p $CARGO_HOME
  '';

  buildPhase = ''
    runHook preBuild

    echo "Installing dependencies with bun..."
    bun install --frozen-lockfile --no-progress

    echo "Building native Rust module..."
    cd packages/natives
    bun run build:native
    cd ../..

    echo "Building omp binary using official build:binary script..."
    bun --cwd=packages/coding-agent run build:binary

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    if [ -f packages/coding-agent/dist/omp ]; then
      cp packages/coding-agent/dist/omp $out/bin/omp
    elif [ -f omp ]; then
      cp omp $out/bin/omp
    else
      echo "ERROR: Binary not found at packages/coding-agent/dist/omp or ./omp"
      find . -name "omp" -type f 2>/dev/null
      exit 1
    fi

    chmod +x $out/bin/omp

    runHook postInstall
  '';

  meta = {
    description = "AI coding agent for the terminal";
    homepage = "https://github.com/can1357/oh-my-pi";
    license = lib.licenses.mit;
    mainProgram = "omp";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
