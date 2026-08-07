{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  ...
}:

buildFirefoxXpiAddon {
  pname = "ublock-origin";
  version = "1.72.2";
  addonId = "uBlock0@raymondhill.net";
  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4888680/ublock_origin-1.72.2.xpi";
    sha256 = "40c315b0da7871868155ecfae7a50a58dfa0920aebd865e008214986f1b7c578";
  };
  meta = with lib; {
    homepage = "https://github.com/gorhill/uBlock#ublock-origin";
    description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
    license = licenses.gpl3;
    mozPermissions = [
      "alarms"
      "dns"
      "menus"
      "privacy"
      "storage"
      "tabs"
      "unlimitedStorage"
      "webNavigation"
      "webRequest"
      "webRequestBlocking"
      "<all_urls>"
    ];
    platforms = platforms.all;
  };
}
