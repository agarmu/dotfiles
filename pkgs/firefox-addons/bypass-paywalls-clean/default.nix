{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "bypass-paywalls-clean";
  version = "4.4.2.7";
  addonId = "magnolia@12.34";
  src = fetchurl {
    url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-${version}.xpi";
    hash = "sha256-quOIU4JxCcJ02xuVCXVBxzzaSQiKjn0BqUkQnP6s5NI=";
  };
  meta = with lib; {
    homepage = "https://gitflic.ru/project/magnolia1234/bypass-paywalls-clean";
    description = "Bypass Paywalls of (custom) news sites";
    license = licenses.mit;
    mozPermissions = [
      "cookies"
      "storage"
      "activeTab"
      "webRequest"
      "webRequestBlocking"
      "<all_urls>"
    ];
    platforms = platforms.all;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "firefox-addons.bypass-paywalls-clean";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };
}
