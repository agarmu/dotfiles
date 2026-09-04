{
  callPackage,
  copyDesktopItems,
  desktopToDarwinBundle,
  fetchFromGitHub,
  lib,
  stdenv,
  fontconfig,
  haskellPackages,
  makeWrapper,
  makeDesktopItem,
  nix-update-script,
  xdg-utils,
}:
((callPackage ./haskell-packages.nix { }).callCabal2nix "perspec" (fetchFromGitHub {
  owner = "ad-si";
  repo = "Perspec";
  tag = "v1.1.0.0";
  hash = "sha256-pgrgJlBRu1EzdgWl72Pv+YFK8Ab7UleXvJkg3hT2hvE=";

  # Release archives omit the Cabal file generated from package.yaml.
  postFetch = ''
    chmod -R u+w "$out"
    cd "$out"
    ${haskellPackages.hpack}/bin/hpack
  '';
}) { }).overrideAttrs
  (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [ ./remove-license-message.patch ];

    nativeBuildInputs =
      (oldAttrs.nativeBuildInputs or [ ])
      ++ [ copyDesktopItems ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

    desktopItems = (oldAttrs.desktopItems or [ ]) ++ [
      (makeDesktopItem {
        name = "perspec";
        desktopName = "Perspec";
        comment = "Correct the perspective of photos";
        icon = "perspec";
        exec = "perspec gui";
        categories = [
          "Graphics"
          "ImageProcessing"
          "RasterGraphics"
          "Photography"
          "Scanning"
        ];
      })
    ];

    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        install -Dm644 images/icon.svg "$out/share/icons/hicolor/scalable/apps/perspec.svg"
      ''
      + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram "$out/bin/perspec" \
          --prefix PATH : ${
            lib.makeBinPath [
              fontconfig
              xdg-utils
            ]
          }
      '';

    meta = (oldAttrs.meta or { }) // {
      description = "Scriptable desktop app to correct the perspective of images";
      homepage = "https://github.com/ad-si/Perspec";
      changelog = "https://github.com/ad-si/Perspec/blob/v${oldAttrs.version}/changelog.md";
      license = lib.licenses.agpl3Only;
      mainProgram = "perspec";
      platforms = lib.platforms.unix;
    };

    passthru.updateScript = nix-update-script {
      attrPath = "perspec";
      extraArgs = [ "--flake" ];
    };
  })
