{
  lib,
  stdenvNoCC,
  build-support,
  fetchFromGitHub,
  python3,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nordwand-mono";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "tywr";
    repo = "Nordwand-Mono";
    tag = finalAttrs.version;
    hash = "sha256-OYgQAKwPU6DuRYGGc/iYjK0LQBOPQi314cT+pJl85YY=";
  };

  nativeBuildInputs = [
    (python3.withPackages (
      ps: with ps; [
        booleanoperations
        fonttools
        numpy
        skia-pathops
        ttfautohint-py
        ufolib2
      ]
    ))
  ];

  env.PYTHONPATH = "src";

  buildPhase = ''
    runHook preBuild

    python -m generate_font --ttf

    runHook postBuild
  '';

  nativeInstallCheckInputs = [ build-support.fontCheckHook ];
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/ttf/*.ttf -t "$out/share/fonts/truetype"
    install -Dm644 LICENSE-FONT.txt "$out/share/doc/${finalAttrs.pname}/LICENSE-FONT.txt"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    attrPath = "nordwand-mono";
    extraArgs = [ "--flake" ];
  };

  meta = {
    description = "Compact monospace neo-grotesque font designed for developers";
    homepage = "https://github.com/tywr/Nordwand-Mono";
    changelog = "https://github.com/tywr/Nordwand-Mono/releases/tag/${finalAttrs.version}";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
