{
  lib,
  fetchFromGitHub,
  makeRustPlatform,
  rust-bin,
  stdenv,
  rcodesign,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  makeBinaryWrapper,
  pkg-config,
  autoPatchelfHook,
  alsa-lib,
  fontconfig,
  freetype,
  libxkbcommon,
  libxcb,
  vulkan-loader,
  wayland,
  wl-clipboard,
  xclip,
}:
let
  toolchain = rust-bin.stable."1.96.1".default;
  rustPlatform = makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr-gpui";
  version = "20261028.1";

  src = fetchFromGitHub {
    owner = "penso";
    repo = "herdr-gpui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yUfr7bGYlRohnnZx+ZR+jTX3/ud71cKYlTE2kzIACoI=";
  };

  cargoHash = "sha256-C5Bu85K1lmX5MVC7zDIp9CbAygDlTJ3nLPZrFskAHdo=";
  doCheck = false;
  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
      makeWrapper
      pkg-config
      rustPlatform.bindgenHook
      autoPatchelfHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      makeBinaryWrapper
      rcodesign
    ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fontconfig
    freetype
    libxkbcommon
    libxcb
    vulkan-loader
    wayland
  ];
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    vulkan-loader
    wayland
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "so.pen.herdr-gpui";
      desktopName = "Herdr";
      comment = "Native client for an existing local Herdr daemon";
      exec = "herdr-gpui";
      icon = "herdr-gpui";
      terminal = false;
      categories = [ "Development" ];
      startupWMClass = "so.pen.herdr-gpui";
    })
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 assets/icons/herdr-linux.svg \
      $out/share/icons/hicolor/scalable/apps/herdr-gpui.svg
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/herdr-gpui \
        --prefix PATH : ${
          lib.makeBinPath [
            wl-clipboard
            xclip
          ]
        }
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      app=$out/Applications/Herdr.app/Contents
      mkdir -p "$app/MacOS"
      mv "$out/bin/herdr-gpui" "$app/MacOS/Herdr"
      makeBinaryWrapper "$app/MacOS/Herdr" "$out/bin/herdr-gpui"
      for helper in herdr-acp herdr-automate herdr-remote-control; do
        mv "$out/bin/$helper" "$app/MacOS/$helper"
        makeBinaryWrapper "$app/MacOS/$helper" "$out/bin/$helper"
      done
      install -Dm644 assets/macos/Info.plist "$app/Info.plist"
      install -Dm644 assets/icons/Herdr.icns "$app/Resources/Herdr.icns"
      install -Dm644 assets/icons/Herdr.car "$app/Resources/Assets.car"
      substituteInPlace "$app/Info.plist" \
        --replace-fail '<key>CFBundleShortVersionString</key><string>0.1.0</string>' \
          '<key>CFBundleShortVersionString</key><string>${finalAttrs.version}</string>' \
        --replace-fail '<key>CFBundleVersion</key><string>1</string>' \
          '<key>CFBundleVersion</key><string>${finalAttrs.version}</string>'
      rcodesign sign "$out/Applications/Herdr.app"
      rcodesign sign "$out/bin/herdr-gpui-launcher"
    '';

  meta = {
    description = "Native GPUI client for an existing local Herdr daemon";
    homepage = "https://herdrui.dev";
    license = lib.licenses.asl20;
    mainProgram = "herdr-gpui";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
