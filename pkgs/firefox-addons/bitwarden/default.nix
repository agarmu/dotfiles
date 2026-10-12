{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "bitwarden";
  version = "2026.9.3";
  addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
  src = fetchurl {
    url = "https://github.com/bitwarden/clients/releases/download/browser-v${version}/dist-firefox-${version}.zip";
    hash = "sha256-vveqqWZn8eM4ZukX0YwM2v96O8J3ZhHfGpJCSd7vJSs=";
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
