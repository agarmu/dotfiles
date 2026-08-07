{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "bypass-paywalls-clean";
  version = "4.4.1.5";
  addonId = "magnolia@12.34";
  src = fetchurl {
    url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-${version}.xpi";
    sha256 = "sha256-VYWZ6wZJA2UtPK7KcdQH/cMNfz2ga6AH27z4ThV5ab0=";
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
}
