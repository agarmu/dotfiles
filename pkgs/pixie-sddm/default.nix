{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "pixie-sddm";

  src = fetchFromGitHub {
    owner = "xCaptaiN09";
    repo = "pixie-sddm";
    rev = "main";
    sha256 = "sha256-lmE/49ySuAZDh5xLochWqfSw9qWrIV+fYaK5T2Ckck8=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/pixie
    cp -r * $out/share/sddm/themes/pixie/
  '';
}
