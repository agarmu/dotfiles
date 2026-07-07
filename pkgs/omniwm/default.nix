{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "omniwm";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/BarutSRB/OmniWM/releases/download/v${version}/OmniWM-v${version}.zip";
    # Use lib.fakeHash to deliberately fail the build and fetch the real hash
    hash = "sha256-8zfA1c/LeWgVNY0j+Kr+zdusasITqhDL81RnYE9I6Hg=";
  };

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications/

    makeWrapper $out/Applications/OmniWM.app/Contents/MacOS/OmniWM $out/bin/OmniWM
    makeWrapper $out/Applications/OmniWM.app/Contents/MacOS/omniwmctl $out/bin/omniwmctl
    runHook postInstall
  '';

  meta = with lib; {
    description = "MacOS Niri and Hyprland inspired tiling window manager";
    homepage = "https://github.com/BarutSRB/OmniWM";
    license = licenses.gpl2Only;
    platforms = platforms.darwin;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "omniwm";
    extraArgs = [ "--flake" ];
  };
}
