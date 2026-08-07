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
    url = "https://github.com/bitwarden/clients/releases/download/browser-v${version}/dist-firefox-${version}.zip";
    hash = "sha256-hkLBcoR7G4WUVnAuo4z9p+BRmkUEXYqPsF0q8TNocFM=";
  };
  meta = with lib; {
    homepage = "https://bitwarden.com";
    description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
    license = licenses.gpl3;
    mozPermissions = [
      "<all_urls>"
      "alarms"
      "clipboardRead"
      "clipboardWrite"
      "contextMenus"
      "idle"
      "storage"
      "tabs"
      "unlimitedStorage"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "notifications"
    ];
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
