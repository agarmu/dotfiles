{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "titillium-web";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "e7db6ca603fd4862010383ff17ffd6cc4ffac1c0";
    hash = "sha256-urpY11cNmDElW/qoklYAx2lvvj/mDFkii/6IEOGoD0g=";
    sparseCheckout = [ "ofl/titilliumweb" ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    find ofl/titilliumweb -type f -name '*.ttf' \
      -exec install -m644 -t $out/share/fonts/truetype {} +

    install -Dm644 ofl/titilliumweb/OFL.txt \
      $out/share/licenses/titillium-web/OFL.txt

    runHook postInstall
  '';

  meta = {
    description = "Titillium Web typeface";
    homepage = "https://fonts.google.com/specimen/Titillium+Web";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
