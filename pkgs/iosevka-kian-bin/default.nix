{
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "iosevka-kian-bin";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "agarmu";
    repo = "iosevka-kian";
    tag = finalAttrs.version;
    hash = "sha256-A60WkTJSuhJw1oQwjQXTEY0f9SUxb9wyf3w1XkNGnKQ=";
  };
  dontInstall = true;
  unpackPhase = ''
    mkdir -p $out/share/fonts
    cp -r $src/truetype $out/share/fonts/truetype
  '';

  passthru.updateScript = nix-update-script {
    attrPath = "iosevka-kian-bin";
    extraArgs = [ "--flake" ];
  };
})
