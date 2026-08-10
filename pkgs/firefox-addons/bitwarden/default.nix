{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "bitwarden";
  version = "2026.7.0";
  addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4915668/bitwarden_password_manager-${version}.xpi";
    hash = "sha256-EYNuudKryZFLsze1fiDFoJz0TyT6Vy9+iGOE/TUKURI=";
  };
  meta = with lib; {
    homepage = "https://bitwarden.com";
    description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
    license = licenses.gpl3;
    platforms = platforms.all;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "firefox-addons.bitwarden";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };
}
