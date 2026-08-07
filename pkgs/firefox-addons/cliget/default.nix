{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "cliget";
  version = "2.1.0";
  addonId = "cliget@zaidabdulla.com";
  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/3707199/cliget-2.1.0.xpi";
    hash = "sha256-UnfajzsFH8HAV0JSDuzVvn6kRWOBYdLIb1RronJG22E=";
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

  passthru.updateScript = nix-update-script {
    attrPath = "firefox-addons.cliget";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };
}
