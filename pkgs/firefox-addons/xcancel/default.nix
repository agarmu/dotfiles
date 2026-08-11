{
  buildFirefoxXpiAddon,
  fetchurl,
  nix-update-script,
  lib,
  ...
}:

buildFirefoxXpiAddon rec {
  pname = "xcancel";
  version = "4.1";
  addonId = "{7b74340a-30bf-4a45-aefa-8a0de3096062}";
  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4699017/nitter-4.1.xpi";
    hash = "sha256-bQploGBMkbZuEzZPRn2//NpfywIyHUXQhN+Bcmn+beI=";
  };
  meta = with lib; {
    homepage = "https://addons.mozilla.org/en-US/firefox/addon/xcancel/";
    description = "Use XCancel instead of Twitter.";
    license = licenses.mit;
    mozPermissions = [
      "webRequest"
      "webRequestBlocking"
      "*://*.twitter.com/*"
      "*://*.x.com/*"
    ];
    platforms = platforms.all;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "firefox-addons.xcancel";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };
}
