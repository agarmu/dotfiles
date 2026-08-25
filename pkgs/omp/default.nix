{
  bun,
  cmake,
  darwin,
  fetchFromGitHub,
  lib,
  libiconv,
  libopus,
  ninja,
  openssl,
  pkg-config,
  rust-bin,
  rustPlatform,
  stdenv,
  stdenvNoCC,
  unzip,
  removeReferencesTo,
}:

let
  pname = "oh-my-pi";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "oh-my-pi";
    tag = "v${version}";
    hash = "sha256-hVgG5fIBAxG58uNJLQRsueSi5ffgWGyF9/qCftiDWt0=";
    fetchSubmodules = true;
  };

  platform =
    {
      aarch64-darwin = {
        addon = "pi_natives.darwin-arm64.node";
        nativeLibrary = "libpi_natives.dylib";
      };
      aarch64-linux = {
        addon = "pi_natives.linux-arm64.node";
        nativeLibrary = "libpi_natives.so";
      };
      x86_64-darwin = {
        addon = "pi_natives.darwin-x64-baseline.node";
        nativeLibrary = "libpi_natives.dylib";
        rustFlags = "-C target-cpu=x86-64-v2";
      };
      x86_64-linux = {
        addon = "pi_natives.linux-x64-baseline.node";
        nativeLibrary = "libpi_natives.so";
        rustFlags = "-C target-cpu=x86-64-v2";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported OMP platform: ${stdenv.hostPlatform.system}");

  bunRuntimeTemplate = stdenvNoCC.mkDerivation {
    pname = "omp-bun-runtime-template";
    inherit (bun) version;
    inherit (bun) src;
    nativeBuildInputs = [ unzip ];
    dontUnpack = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      unzip -q "$src"
      install -Dm755 bun-*/bun "$out/libexec/bun"
      runHook postInstall
    '';
  };

  bunDeps = stdenvNoCC.mkDerivation {
    pname = "${pname}-bun-deps";
    inherit version;
    inherit src;
    nativeBuildInputs = [ bun ];
    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild
      export HOME="$TMPDIR/home"
      mkdir -p "$HOME"
      bun install --frozen-lockfile --no-progress --linker=isolated --backend=copyfile
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -R node_modules "$out/"
      mkdir -p "$out/workspaces"
      while IFS= read -r workspaceDir; do
        mkdir -p "$out/workspaces/$workspaceDir"
        cp -R "$workspaceDir/node_modules" "$out/workspaces/$workspaceDir/"
      done < <(find packages -mindepth 2 -maxdepth 2 -type d -name node_modules -exec dirname {} \;)
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-DpA1Gvu5yxwx6SSfyH1fuMRQrdRVUrcx727J58BoJMg=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    bun
    cmake
    ninja
    pkg-config
    removeReferencesTo
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rust-bin.nightly.latest.default
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
    darwin.sigtool
  ];

  buildInputs = [
    libiconv
    libopus
    openssl
  ];

  strictDeps = true;
  dontConfigure = true;
  dontRunLifecycleScripts = true;
  dontStrip = true;

  env = {
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
    PCRE2_SYS_STATIC = "1";
    SOURCE_DATE_EPOCH = "1";
  }
  // lib.optionalAttrs (platform ? rustFlags) { RUSTFLAGS = platform.rustFlags; };

  buildPhase = ''
    runHook preBuild

    cp -R ${bunDeps}/node_modules ./node_modules
    cp -R ${bunDeps}/workspaces/. ./
    chmod -R u+w node_modules

    # Bun's isolated linker does not retain workspace-package links when its
    # node_modules tree is copied out of the fixed-output dependency build.
    # Recreate those links from the fetched workspace manifests instead of
    # vendoring generated package metadata in this expression.
    while IFS= read -r packageJson; do
      packageDir="''${packageJson%/package.json}"
      packageName="$(sed -n 's/.*\"name\": *\"\([^\"]*\)\".*/\1/p' "$packageJson" | head -n 1)"
      case "$packageName" in
        @oh-my-pi/*)
          mkdir -p "node_modules/''${packageName%%/*}"
          ln -s "$PWD/$packageDir" "node_modules/$packageName"
          ;;
      esac
    done < <(find packages -mindepth 2 -maxdepth 2 -type f -name package.json)

    echo "Building pi-natives"
    cargo build --release -p pi-natives
    install -Dm755 "target/release/${platform.nativeLibrary}" \
      "packages/natives/native/${platform.addon}"

    echo "Compiling OMP"
    bun --cwd="$PWD/packages/coding-agent" run generate-docs-index
    BUN_COMPILE_EXECUTABLE_PATH="${bunRuntimeTemplate}/libexec/bun" \
      bun --cwd="$PWD/packages/coding-agent" run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 packages/coding-agent/dist/omp "$out/bin/omp"
    install -Dm644 LICENSE "$out/share/doc/omp/LICENSE"
    if [ -f THIRD-PARTY-NOTICES.txt ]; then
      install -Dm644 THIRD-PARTY-NOTICES.txt "$out/share/doc/omp/THIRD-PARTY-NOTICES.txt"
    fi
    runHook postInstall
  '';

  preFixup = ''
    remove-references-to -t ${bun} "$out/bin/omp"
  '';

  disallowedReferences = [ bun ];

  meta = {
    description = "Terminal-based coding agent with multi-model support";
    homepage = "https://omp.sh";
    changelog = "https://github.com/can1357/oh-my-pi/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "omp";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      fromSource
    ];
  };
}
