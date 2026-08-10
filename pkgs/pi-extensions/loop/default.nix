{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-loop";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "kolt-mcb";
    repo = "pi-loop";
    rev = "ef10308227fed281c7f0898da48a37afb08c5787";
    hash = "sha256-xHoOiitwHYJJ8BwMaJKBAkV0aq2/oIQM+FxUrQ1jxOU=";
  };

  # The extension has no runtime npm dependencies; Pi provides its peer APIs.
  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Timer-, event-, and model-driven /loop scheduling for Pi";
    homepage = "https://github.com/kolt-mcb/pi-loop";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
