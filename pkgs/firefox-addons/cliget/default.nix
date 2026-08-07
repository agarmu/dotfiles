{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  ...
}:

buildFirefoxXpiAddon {
  pname = "cliget";
  version = "2.1.0";
  addonId = "cliget@zaidabdulla.com";
  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/3707199/cliget-2.1.0.xpi";
    sha256 = "5277da8f3b051fc1c05742520eecd5be7ea445638161d2c86f546ba27246db61";
  };
  meta = with lib; {
    homepage = "https://github.com/zaidka/cliget";
    description = "Download login-protected files from the command line using curl, wget or aria2.";
    license = licenses.mpl20;
    mozPermissions = [
      "webRequest"
      "storage"
      "<all_urls>"
    ];
    platforms = platforms.all;
  };
}
