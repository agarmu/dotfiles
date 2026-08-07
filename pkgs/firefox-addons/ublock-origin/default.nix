{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "ublock-origin";
  version = "1.73.0";
  addonId = "uBlock0@raymondhill.net";
  src = fetchurl {
    url = "https://github.com/gorhill/uBlock/releases/download/${version}/uBlock0_${version}.firefox.signed.xpi";
    hash = "sha256-vMxRp3MVCvSvbh/WLHv963I4t5/yOBuZj6ny449keGo=";
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

  passthru.updateScript = nix-update-script {
    attrPath = "firefox-addons.ublock-origin";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };
}
