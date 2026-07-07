{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  zip,
}:

stdenvNoCC.mkDerivation {
  pname = "zotero-abstract-cleaner";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dcartertod";
    repo = "zotero-plugins";
    rev = "56b3ce63f999664eb2034968890132aad53b8f16";
    hash = "sha256-YQ32DQm5aTIMJQegjXYBkxYM1BI39QAE1czSm9f+ZGw=";
  };

  sourceRoot = "source/ZoteroAbstractCleaner7";

  nativeBuildInputs = [ zip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/zotero/addons
    zip -DX -r $out/share/zotero/addons/zotero-abstract-cleaner.xpi . -x "**/.*"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fix line endings in abstracts copied from PDFs";
    homepage = "https://github.com/dcartertod/zotero-plugins";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
