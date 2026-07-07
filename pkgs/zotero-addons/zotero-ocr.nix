{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  tesseract,
  poppler,
  zip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zotero-ocr";
  version = "0.9.5.1";

  src = fetchFromGitHub {
    owner = "UB-Mannheim";
    repo = "zotero-ocr";
    tag = "0.9.5.1";
    hash = "sha256-7rXx8h26LUumZTWczFCGnXOMNNMPMIvICfAiqfop3p0=";
  };

  nativeBuildInputs = [ zip ];

  buildInputs = [
    tesseract
    poppler
  ];

  postPatch = ''
    sed -i \
      -e 's|^\(\s*let pdftoppmPaths\s*=\s*\)\[.*\];|\1["${poppler}/bin/"];|' \
      -e 's|^\(\s*let ocrEnginePaths\s*=\s*\)\[.*\];|\1["${tesseract}/bin/"];|' \
      src/zotero-ocr.js
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/zotero/addons
    pushd src
    zip -DX -r $out/share/zotero/addons/zotero-ocr-${version}.xpi * -x "**/.*"
    popd
    runHook postInstall
  '';

  meta = with lib; {
    description = "Zotero plugin adding OCR functionality for PDFs using Tesseract";
    homepage = "https://github.com/UB-Mannheim/zotero-ocr";
    license = licenses.agpl3Only;
    platforms = platforms.all;
  };
}
