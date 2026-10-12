{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "zotero-connector";
  version = "5.0.217";
  addonId = "zotero@chnm.gmu.edu";
  src = fetchurl {
    url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-${version}.xpi";
    hash = "sha256-lF/XwOyO3VXC24NLL7JHEzPXMASUuWEtg/ky0lh3uDQ=";
  };
  mozPermissions = [
    "http://*/*"
    "https://*/*"
    "tabs"
    "contextMenus"
    "cookies"
    "storage"
    "scripting"
    "webRequest"
    "webRequestBlocking"
    "webNavigation"
    "declarativeNetRequest"
    "management"
    "clipboardWrite"
  ];
  meta = with lib; {
    homepage = "https://www.zotero.org/";
    description = "Save references to Zotero from your web browser";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "firefox-addons.zotero-connector";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };
}
