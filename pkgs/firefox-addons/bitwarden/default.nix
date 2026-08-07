{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  ...
}:

buildFirefoxXpiAddon {
  pname = "bitwarden";
  version = "2026.7.0";
  addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4915668/bitwarden_password_manager-2026.7.0.xpi";
    sha256 = "11836eb9d2abc9914bb337b57e20c5a09cf44f24fa572f7e886384fd350a5112";
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
}
