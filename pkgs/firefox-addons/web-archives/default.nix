{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "web-archives";
  version = "7.3.3";
  addonId = "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}";
  src = fetchurl {
    url = "https://github.com/dessant/web-archives/releases/download/v${version}/web_archives-${version}-firefox.zip";
    hash = "sha256-CayoaA6USsvjwfkQ2tr460u0xXztNMyqXH7TCBC+e8I=";
  };
  meta = with lib; {
    homepage = "https://github.com/dessant/web-archives#readme";
    description = "View archived and cached versions of web pages on various search engines, such as the Wayback Machine and Archive․is.";
    license = licenses.gpl3Only;
    mozPermissions = [
      "alarms"
      "contextMenus"
      "storage"
      "unlimitedStorage"
      "tabs"
      "activeTab"
      "notifications"
      "webRequest"
      "webRequestBlocking"
      "<all_urls>"
      "scripting"
    ];
    platforms = platforms.all;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "firefox-addons.web-archives";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };
}
