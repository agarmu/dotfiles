{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  ...
}:

buildFirefoxXpiAddon {
  pname = "web-archives";
  version = "7.3.3";
  addonId = "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}";
  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4871262/view_page_archive-7.3.3.xpi";
    sha256 = "81ca25bd41392cf4b03d4c1c4c39ebd5a4eaa840ef8a4d26f84b1dd396999a34";
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
}
